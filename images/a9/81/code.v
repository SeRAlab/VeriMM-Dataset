module top_module(
    d_readdatain,
    d_loadresult);input [31:0] d_readdatain;

output [31:0] d_loadresult;

wire d_adr_one;
assign d_adr_one = d_address [1];
reg [31:0] d_loadresult;
reg sign;
wire [1:0] d_address;
assign d_address [1:0] =d_readdatain [25:24];



always @(d_readdatain or d_address )
begin
            d_loadresult[31:0]=d_readdatain[31:0];
end

endmodule