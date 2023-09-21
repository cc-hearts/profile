import fetch, {type RequestInit } from 'node-fetch'

export function request(url: string, options: RequestInit = {}) {
  if (!options.headers)
    options.headers = {
      'Content-Type': 'application/json',
    }
  else if (!Reflect.get(options.headers, 'Content-Type'))
    Reflect.set(options.headers, 'Content-Type', 'application/json')

  if (!options.method) options.method = 'get'
  return fetch(url, options).then((res) => {
    const contentType = res.headers.get('content-type')
    if (contentType?.includes('application/json;')) {
      return res.json()
    }
    return res.text()
  })
}