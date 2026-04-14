module top_module(
    input clk,
    input reset,
    input up_down,
    input load,
    input select,
    output reg [3:0] shifted_count,
    input [3:0] data_in
);// Declare internal registers for count
reg [3:0] count;

// Instantiate the up_down_counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000; // Reset count to 0
    end else if (load) begin
        count <= data_in; // Load data_in into count
    end else begin
        // Up/Down counting logic
        count <= up_down ? count + 1 : count - 1;
    end
end

// Shifted value logic
always @(*) begin
    case (select)
        2'b00: shifted_count = count; // No shift
        2'b01: shifted_count = count << 1; // Shift left
        2'b10: shifted_count = count >> 1; // Shift right
        default: shifted_count = count; // Default case
    endcase
end

endmodule