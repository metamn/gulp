---
title: YAML
---

<p>{{ title }}</p>


{% for i in [1, 2, 3] %}
  {{ i }}
{% endfor %}


{% include "../atoms/test.html" with { name : "lolka" } %}
