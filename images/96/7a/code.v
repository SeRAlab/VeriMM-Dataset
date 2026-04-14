module top_module(cn, price);input [9:0] cn;

    output [16:0] price;
    reg [16:0] price;

    always@(cn) begin
        if(cn < 256) price <= 100;
        else if(cn < 512) price <= 500;
        else price <= 1000;
    end
endmodule