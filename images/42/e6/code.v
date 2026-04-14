module top_module(
    input clk,               // Clock input
    input clock_enable,      // Clock enable input
    input reset,             // Asynchronous active-high reset
    input direction,         // Direction input signal
    output reg [3:0] q       // 4-bit output of the counter
);reg [3:0] johnson;          // Johnson counter output
reg [3:0] adder_out;        // Adder output
reg [3:0] adder_in;         // Adder input (changed from wire to reg)

// Johnson counter
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        johnson <= 4'b0001;
    end else if (clock_enable) begin
        johnson <= {johnson[2:0], ~johnson[3]};
    end
end

// Adder control logic
always @(*) begin
    if (direction) begin
        adder_in = johnson + 4'b0001;
    end else begin
        adder_in = johnson - 4'b0001;
    end
end

// Adder
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        adder_out <= 4'b0000;
    end else if (clock_enable) begin
        adder_out <= adder_in;
    end
end

// Output
assign q = adder_out;

endmodule