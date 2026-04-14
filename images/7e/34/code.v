module top_module(
    input wire clock,
    input wire reset,
    input wire Stall,
    input wire [31:0] pc_next,
    output reg [31:0] pc
    );always @(posedge clock, negedge reset) begin
        if (~reset)
            pc = 0;
        else if (~Stall)
            pc = pc_next;
    end  
endmodule