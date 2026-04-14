module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] d,    // 8-bit input for the register
    output [3:0] counter_out, // 4-bit counter output
    output [7:0] max_out // Maximum value between the register and counter outputs
);reg [7:0] reg_out;
    reg [3:0] counter;
    
    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 8'h34;
            counter <= 4'b0;
        end else begin
            reg_out <= d;
            counter <= counter + 1;
        end
    end
    
    assign counter_out = counter;
    
    // Extend counter output to 8 bits
    wire [7:0] counter_ext = {4'b0, counter};
    
    // Functional module to output maximum value
    assign max_out = (reg_out > counter_ext) ? reg_out : counter_ext;

endmodule