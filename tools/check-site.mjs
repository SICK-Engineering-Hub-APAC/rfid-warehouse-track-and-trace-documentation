import { readFile, readdir } from 'node:fs/promises';
import path from 'node:path';
import { parse } from 'parse5';

const root = path.resolve(process.argv[2] || '_site');
const files = new Set();
const documents = new Map();
const errors = [];
const origin = 'https://documentation.invalid';

async function collect(directory, prefix = '') {
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const relative = prefix + entry.name;
    if (entry.isDirectory()) {
      await collect(path.join(directory, entry.name), relative + '/');
    } else {
      files.add(relative);
    }
  }
}

function visit(node, callback) {
  callback(node);
  for (const child of node.childNodes || []) visit(child, callback);
}

await collect(root);
for (const file of files) {
  if (!file.endsWith('.html')) continue;
  const tree = parse(await readFile(path.join(root, file), 'utf8'));
  const ids = new Set();
  const links = [];
  visit(tree, node => {
    const attrs = Object.fromEntries((node.attrs || []).map(attr => [attr.name, attr.value]));
    if (attrs.id) ids.add(attrs.id);
    if (node.tagName === 'a' && attrs.name) ids.add(attrs.name);
    for (const attribute of ['href', 'src', 'poster']) {
      if (attrs[attribute]) links.push(attrs[attribute]);
    }
    if (node.tagName === 'meta' && attrs['http-equiv']?.toLowerCase() === 'refresh') {
      const target = attrs.content?.match(/url\s*=\s*(.+)$/i)?.[1];
      if (target) links.push(target.trim());
    }
  });
  documents.set(file, { ids, links });
}

for (const [file, document] of documents) {
  for (const link of document.links) {
    let target;
    try {
      target = new URL(link, `${origin}/${file}`);
    } catch {
      errors.push(`${file}: invalid URL ${link}`);
      continue;
    }
    if (target.origin !== origin) continue;
    if (link.startsWith('/')) {
      errors.push(`${file}: root-relative URL breaks GitHub project Pages: ${link}`);
      continue;
    }
    let destination = decodeURIComponent(target.pathname.slice(1));
    if (!destination || destination.endsWith('/')) destination += 'index.html';
    if (!files.has(destination)) {
      errors.push(`${file}: missing target (case-sensitive) ${link}`);
      continue;
    }
    const fragment = decodeURIComponent(target.hash.slice(1));
    if (fragment && documents.has(destination) && !documents.get(destination).ids.has(fragment)) {
      errors.push(`${file}: missing anchor ${link}`);
    }
  }
}

if (!documents.has('index.html') || !documents.has('usage-manual/index.html')) {
  errors.push('Missing documentation homepage or latest manual entry point.');
}
if (errors.length) {
  console.error(errors.join('\n'));
  process.exitCode = 1;
} else {
  console.log(`Validated ${documents.size} HTML pages and their local links/assets across ${files.size} files.`);
}