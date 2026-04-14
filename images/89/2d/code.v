module top_module(
    input clk,    // Clocks are used in sequential circuits
    input reset,
    input [1:0] d,
    output reg [1:0] q );reg [1:0] q_reg1, q_reg2;   // Two D flip-flops
    
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            q_reg1 <= 2'b0;
            q_reg2 <= 2'b0;
        end else begin
            q_reg1 <= d;
            q_reg2 <= q_reg1;
        end
    end
    
    // Output the value after 4 clock cycles
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            q <= 2'b0;
        end else if ($time % 4 == 0) begin
            q <= q_reg2;
        end
    end
    
endmodule