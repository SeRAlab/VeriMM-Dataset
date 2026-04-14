module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,
    input select,     // Select input to choose between modes
    output [7:0] q
);// Mode 1: D flip-flops triggered by negative edge of clk
    reg [7:0] mode1_q;
    always @(negedge clk, posedge reset) begin
        if (reset) begin
            mode1_q <= 8'b0;
        end else begin
            mode1_q <= d;
        end
    end
    
    // Mode 2: D flip-flops created using T flip-flops and logic gates
    reg [7:0] mode2_q;
    wire [7:0] mode2_t;
    assign mode2_t = mode2_q ^ d;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            mode2_q <= 8'b0;
        end else begin
            mode2_q <= mode2_t;
        end
    end
    
    // Mode select logic
    wire mode1_select = ~select;
    wire mode2_select = select;
    
    // Output sum of mode 1 and mode 2
    assign q = mode1_select ? mode1_q : mode2_q + mode1_q;

endmodule