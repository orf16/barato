import re
from django import template
from django.template.defaultfilters import stringfilter

register = template.Library()

@stringfilter
def format_thousands(val):
    '''
    Format a number so that it's thousands are separated by commas. 
    
    1000000 > '1,000,000'
    10000 > '10,000'
    1000.00 > '10,000.00'
    '''
    return ','.join(re.findall('((?:\d+\.)?\d{1,3})', val[::-1]))[::-1]


register.filter('format_thousands', format_thousands)
