module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    output [3:0] q,
    input in,
    output out,
    input [3:0] counter_out,
    output [3:0] sum_out
);// 4-bit binary counter with synchronous reset
    reg [3:0] counter;
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1;
        end
    end
    
    // 2's complement module
    reg [3:0] twos_comp;
    always @(*) begin
        twos_comp = ~counter + 4'b0001;
    end
    
    // Multiplexer module
    reg [3:0] mux_out;
    always @(*) begin
        if (in) begin
            mux_out = twos_comp;
        end else begin
            mux_out = counter;
        end
    end
    
    // Output sum
    assign sum_out = mux_out + in;
    
    // Output signals
    assign q = counter;
    assign out = twos_comp;
    
endmodule