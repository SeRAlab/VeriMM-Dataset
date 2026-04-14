module top_module(
    input [7:0] data_in,
    input [3:0] selector,
    output reg [7:0] data_out  // Changed to reg type
);// Define masks for use in operations
parameter [7:0] MASK_AND = 8'hF0;
parameter [7:0] MASK_OR = 8'h0F;
parameter [7:0] MASK_XOR = 8'h55;

// Define intermediate signals for use in operations
wire [7:0] not_data;
wire [7:0] shifted_left;
wire [7:0] shifted_right;
wire [7:0] anded_data;
wire [7:0] ored_data;
wire [7:0] xored_data;

// Perform operations based on selector input
assign not_data = ~data_in;
assign shifted_left = {data_in[6:0], 1'b0};
assign shifted_right = {1'b0, data_in[7:1]};
assign anded_data = data_in & MASK_AND;
assign ored_data = data_in | MASK_OR;
assign xored_data = data_in ^ MASK_XOR;

always @(*) begin
    case (selector)
        4'b0000: data_out = data_in;
        4'b0001: data_out = not_data;
        4'b0010: data_out = shifted_left;
        4'b0011: data_out = shifted_right;
        4'b0100: data_out = anded_data;
        4'b0101: data_out = ored_data;
        4'b0110: data_out = xored_data;
        4'b0111: data_out = ~data_in + 1;
        default: data_out = data_in;
    endcase
end

endmodule