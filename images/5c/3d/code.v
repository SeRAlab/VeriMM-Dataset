module top_module(
    input clk,
    input reset,
    input ld,
    input data_in,
    input [3:0] d,
    output reg [3:0] q
);reg [3:0] shift_reg;
reg [3:0] up_counter;

// Shift Register with Parallel Load and Asynchronous Reset
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        shift_reg <= 4'b0000;
    end else begin
        if (ld) begin
            shift_reg <= data_in;
        end else begin
            shift_reg <= {shift_reg[2:0], d[0]};
        end
    end
end

// Up Counter with Synchronous Reset and Load Inputs
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        up_counter <= 4'b0000;
    end else begin
        if (ld) begin
            up_counter <= data_in;
        end else begin
            up_counter <= up_counter + 1;
        end
    end
end

// Functional Module that performs bitwise AND operation
always @(posedge clk) begin
    q <= shift_reg & up_counter;
end

endmodule