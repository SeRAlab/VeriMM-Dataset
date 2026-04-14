module top_module(
    input wire [7:0] new_PC,
    output reg [7:0] PC,
    input wire clk,
    input wire rst_
);always @(posedge clk, negedge rst_) begin
        if (rst_ == 1'b0)
            PC <= 0;
        else
            PC <= new_PC;
    end
    
endmodule