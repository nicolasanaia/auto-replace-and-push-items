const replace = require('replace-in-file');

const str = 'REGION: !Ref Region\n        TENANT: !Ref Tenant';

const regex = new RegExp(str);

const options = {
    files: '../../../../',
    from: regex,
    to: 'REGION: !Ref Region\n        TENANT: !Ref Tenant\n        ACCOUNT_NUMBER: !Ref AWS::AccountId',
    dry: false
};

const str2 = 'Environment:\n            - Name: STAGE\n              Value: !Ref Stage\n            - Name: TENANT\n              Value: !Ref Tenant\n            - Name: REGION\n              Value: !Ref Region\n';

const regex2 = new RegExp(str2);

const options2 = {
    files: '',
    from: regex2,
    to: 'Environment:\n            - Name: STAGE\n              Value: !Ref Stage\n            - Name: TENANT\n              Value: !Ref Tenant\n            - Name: REGION\n              Value: !Ref Region\n            - Name: ACCOUNT_NUMBER\n              Value: !Ref AWS::AccountId\n',
    dry: false
};

async function main() {
    try {
        const results = await replace(options)
        const results2 = await replace(options2)

        // for (results2.)

        console.log('Replacement results:', results)
        console.log('Replacement results:', results2)
    } catch (error) {
        console.error('Error occurred:', error)
    }
}

main();
