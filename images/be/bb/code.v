module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] in, // 8-bit input vector
    input select, // Select input to choose between modules
    output reg [7:0] anyedge, // Output from the active module
    output reg [7:0] combined_out // Combined output from the first module and the input vector
);reg [7:0] prev_in; // Previous value of each input bit
reg [7:0] curr_in; // Current value of each input bit
reg [7:0] prev_out; // Previous value of the shift register
reg [7:0] curr_out; // Current value of the shift register

// Rising edge detection module for the input vector
always @(posedge clk) begin
    if (reset) begin
        prev_in <= 8'b0;
        anyedge <= 8'b0;
    end else begin
        prev_in <= curr_in;
        curr_in <= in;
        anyedge <= (curr_in & ~prev_in);
    end
end

// Combined rising edge detection module
always @(posedge clk) begin
    if (reset) begin
        prev_out <= 8'b0;
        combined_out <= 8'b0;
    end else begin
        prev_out <= curr_out;
        curr_out <= {anyedge, in};
        combined_out <= (curr_out & ~prev_out);
    end
end

// Bitwise OR module to combine the outputs
always @(*) begin
    if (select) begin
        anyedge <= 8'b0;
    end else begin
        combined_out <= 8'b0;
    end
end

endmodule