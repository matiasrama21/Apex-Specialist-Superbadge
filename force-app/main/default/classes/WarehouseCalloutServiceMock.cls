@SuppressWarnings('PMD')
@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        List<String> body = new List<String>{
            '[',
                '{',
                    '"_id":"55d66226726b611100aaf741",',
                    '"name":"Generator 1000 kW",',
                    '"replacement":false,',
                    '"cost":5000,',
                    '"quantity":5,',
                    '"lifespan":120,',
                    '"maintenanceperiod":365,',
                    '"sku":"100003"',
                '},',
                '{',
                    '"_id":"55d66226726b611100aaf742",',
                    '"name":"Cooling Fan",',
                    '"replacement":true,',
                    '"cost":300,',
                    '"quantity":183,',
                    '"lifespan":0,',
                    '"maintenanceperiod":0,',
                    '"sku":"100004"',
                '},',
                '{',
                    '"_id":"55d66226726b611100aaf743",',
                    '"name":"Fuse 20A",',
                    '"replacement":true,',
                    '"cost":22,',
                    '"quantity":143,',
                    '"lifespan":0,',
                    '"maintenanceperiod":0,',
                    '"sku":"100005"',
                '}',
            ']'
        };
        response.setBody(String.join(body, ''));
        response.setStatusCode(200);

        return response;
    }
}