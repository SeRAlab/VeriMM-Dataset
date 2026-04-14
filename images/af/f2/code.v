module top_module(
    input clk,
    input reset,
    input serial_in,
    input shift,
    input [7:0] in,
    output reg out,
    output reg valid,
    output reg [2:0] index,
    output reg [3:0] final_output  // Changed to reg
);reg [3:0] shift_reg;
reg [2:0] highest_priority;

// Shift register
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else if (shift) begin
        shift_reg <= {shift_reg[2:0], serial_in};
    end
end

// Priority encoder
always @(in) begin
    if (in[7]) begin
        highest_priority <= 3'b111;
    end else if (in[6]) begin
        highest_priority <= 3'b110;
    end else if (in[5]) begin
        highest_priority <= 3'b101;
    end else if (in[4]) begin
        highest_priority <= 3'b100;
    end else if (in[3]) begin
        highest_priority <= 3'b011;
    end else if (in[2]) begin
        highest_priority <= 3'b010;
    end else if (in[1]) begin
        highest_priority <= 3'b001;
    end else if (in[0]) begin
        highest_priority <= 3'b000;
    end
end

// Final output selection
always @(highest_priority or shift_reg) begin
    case (highest_priority)
        3'b111: final_output = shift_reg[3:0];
        3'b110: final_output = shift_reg[3:0];
        3'b101: final_output = shift_reg[3:0];
        3'b100: final_output = shift_reg[3:0];
        3'b011: final_output = {2'b00, shift_reg[2:1]};  // Adjusted to 4 bits
        3'b010: final_output = {2'b00, shift_reg[1:0]};  // Adjusted to 4 bits
        3'b001: final_output = {3'b000, shift_reg[0]};   // Adjusted to 4 bits
        3'b000: final_output = 4'b0000;
    endcase
end

// Output signals
always @(highest_priority) begin
    out = in[highest_priority];
    valid = |in;
    index = highest_priority;
end

endmodule