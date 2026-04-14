module top_module(
    input wire [15:0] in,
    input wire a,
    input wire b,
    output reg out
);reg [15:0] shifted_in;
wire [7:0] upper_byte;
wire [7:0] lower_byte;
wire [1:0] majority_input;
wire majority_output;

// Barrel shifter
assign {shifted_in[15:4], shifted_in[3:0]} = in;

// Splitting the input into upper and lower bytes
assign upper_byte = shifted_in[15:8];
assign lower_byte = shifted_in[7:0];

// Instead of reg_module, use a simple D flip-flop for storage
reg [7:0] reg_upper_byte;
reg [7:0] reg_lower_byte;

always @(posedge a or negedge b) begin
    if (!b) begin
        reg_upper_byte <= 8'b0;    // Reset condition
    end else begin
        reg_upper_byte <= upper_byte;
    end
end

always @(posedge a or negedge b) begin
    if (!b) begin
        reg_lower_byte <= 8'b0;    // Reset condition
    end else begin
        reg_lower_byte <= lower_byte;
    end
end

// Connecting to majority gate input
assign majority_input[1] = reg_upper_byte[0]; // Select bit (e.g., LSB) for majority input
assign majority_input[0] = reg_lower_byte[0]; // Select bit (e.g., LSB) for majority input

// Majority gate implementation
assign majority_output = ~(majority_input[0] & majority_input[1]);

// Output of the majority gate
always @* begin
    out = majority_output;
end

endmodule