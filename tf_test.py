import os
import pprint
import requests
from tfc_client import TFCClient
from tfc_client.enums import (
    RunStatus,
    NotificationTrigger,
    NotificationsDestinationType,
)
from tfc_client.models import VCSRepoModel

# Need the TFE_TOKEN as an Env variable
TFE_TOKEN = os.getenv("TFE_TOKEN", None)

### Functions
def getOrganizations():
    headers = {'Authorization': f'Bearer {TFE_TOKEN}',
               'Content-Type': 'application/vnd.api+json',
               'charset': 'UTF-8'}
    url = 'https://app.terraform.io/api/v2/organizations'

    response = requests.get(
        url=url,
        headers=headers
    )
    return response.json()

# Get the organization id
organizations = getOrganizations()
pp = pprint.PrettyPrinter(indent=4)
# print(f'getOrganizations: {organizations}')
# pp.pprint(organizations)
pp.pprint(organizations['data'][0]['id'])

# Instantiate the client
client = TFCClient(token=TFE_TOKEN)
my_org = client.get("organization", id=organizations['data'][0]['id'])
print(my_org)