module top_module(client_req, bits);parameter WIDTH = 2;
    output client_req;
    input [WIDTH-1:0] bits;
    assign client_req = &bits;
endmodule