module top_module(output reg pready,
output reg [7:0]prdata,
input psel,penable,pclk,pwrite,
input [7:0]pwdata,
input [7:0]paddr
);reg [7:0]RAM[0:7];

    always @ (posedge pclk)begin
    if(psel)begin
    pready<=1;
        if(penable)begin
            if(pwrite)
            RAM[paddr]<=pwdata;
            else
            prdata<=RAM[paddr];
    end
    end
    else
    pready<=0;
    end

endmodule