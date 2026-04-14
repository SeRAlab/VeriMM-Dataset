module top_module(
    input CLK,
    input EN,
    input WE,
    input [ADDR_WIDTH-1:0] ADDR,
    input [DATA_WIDTH-1:0] DI,
    output [DATA_WIDTH-1:0] DO
);parameter PIPELINED = 0;
parameter ADDR_WIDTH = 1;
parameter DATA_WIDTH = 1;
parameter MEMSIZE = 1;

reg [DATA_WIDTH-1:0] RAM [0:MEMSIZE-1];
reg [DATA_WIDTH-1:0] DO_R;
reg [DATA_WIDTH-1:0] DO_R2;

always @(posedge CLK) begin
    if (EN) begin
        if (WE) begin
            RAM[ADDR] <= DI;
            DO_R <= DI;
        end else begin
            DO_R <= RAM[ADDR];
        end
    end
    DO_R2 <= DO_R;
end

assign DO = (PIPELINED) ? DO_R2 : DO_R;

endmodule