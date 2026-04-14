module synchronous_ram(
    input            clk   ,
    input            we    ,
    input  [3:0]     addr  ,
    input  [7:0]     din   ,

    output reg [7:0] dout
);

reg [7:0] mem [0:15];

always @(posedge clk)
begin
    if (we) mem[addr] <= din;
    dout <= mem[addr];
end

endmodule