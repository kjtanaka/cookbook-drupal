drupal Cookbook
===============
This cookbook installs Drupal for a testing purpose. The reason of "a testing purpose" is that it turns off `iptables` and `selinux`.

Requirements
------------

#### platform
CentOS 6.5 is supported and tested.

#### cookbooks
This cookbook depends on the following cookbooks.

* mysql
* database
* iptables
* selinux

Attributes
----------

#### drupal::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['drupal']['version']</tt></td>
    <td>Text</td>
    <td>Drupal version</td>
    <td><tt>7.28</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['db_name']</tt></td>
    <td>Text</td>
    <td>Database name</td>
    <td><tt>drupal</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['db_user']</tt></td>
    <td>Text</td>
    <td>Database user name</td>
    <td><tt>drupaladmin</tt></td>
  </tr>
  <tr>
    <td><tt>['drupal']['db_user_password']</tt></td>
    <td>Text</td>
    <td>Database user password</td>
    <td><tt>DrupalDBPassw0rd</tt></td>
  </tr>
</table>

Usage
-----
#### drupal::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `drupal` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[drupal]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

- Author:: Koji Tanaka (<kj.tanaka@gmail.com>)

```text
Copyright:: 2014 FutureGrid Project, Indiana University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```