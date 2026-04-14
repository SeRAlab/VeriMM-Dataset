module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input load,       // Active-high parallel load input
    input [3:0] load_value, // 4-bit load value
    input [1:0] ena, // Left/right enable inputs for the rotator
    input [99:0] data, // Input for the rotator
    output [3:0] counter_out, // 4-bit output from the counter
    output [99:0] rotator_out, // 100-bit output from the rotator
    output [103:0] final_out // Sum of counter and rotator outputs
);reg [3:0] counter;
reg [99:0] rotator_reg;

// Counter module
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 4'b1000; // Reset value of 8
    end else if (load) begin
        counter <= load_value;
    end else begin
        counter <= counter + 1;
    end
end

assign counter_out = counter;

// Rotator module
always @(posedge clk) begin
    if (ena == 2'b00) begin // No rotation
        rotator_reg <= data;
    end else if (ena == 2'b01) begin // Right rotation
        rotator_reg <= {rotator_reg[0], rotator_reg[99:1]};
    end else begin // Left rotation
        rotator_reg <= {rotator_reg[98:0], rotator_reg[99]};
    end
end

assign rotator_out = rotator_reg;

// Adder module
assign final_out = {counter_out, 4'b0} + {8'b0, rotator_out}; // Adjusting sizes for addition

endmodule