module top_module( 
    input clk, 
    input reset,      // Synchronous active-high reset
    input a,          // Input signal to the first XOR gate
    input b,          // Input signal to the first XOR gate
    input c,          // Input signal to the second XOR gate
    input d,          // Input signal to the second XOR gate
    input control,    // Control signal for the tri-state buffer
    output reg [2:0] q // 3-bit output from the system
);reg [3:0] counter;
wire [2:0] counter_out; // Change size to 3 bits as we need a 3-bit output
wire [1:0] xor_out;
wire mult_out;

// Counter module
always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Output module
assign counter_out = counter[2:0];
assign xor_out = {a^b, c^d};
assign mult_out = xor_out[0] * counter_out + xor_out[1] * counter_out;

// Tri-state buffer module
bufif0 tri_buf0 (q[2], control, mult_out);
bufif0 tri_buf1 (q[1], control, mult_out);
bufif0 tri_buf2 (q[0], control, mult_out);

endmodule