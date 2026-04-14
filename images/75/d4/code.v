module top_module(
    input [63:0] data_in,
    input [3:0] control,
    output reg [63:0] data_out // Changed wire to reg
);always @(*) begin
    case(control)
        4'b0000: data_out = {data_in[62:0], 1'b0};
        4'b0001: data_out = {1'b0, data_in[63:1]};
        4'b0010: data_out = {data_in[61:0], 2'b00};
        4'b0011: data_out = {2'b00, data_in[63:2]};
        4'b0100: data_out = {data_in[60:0], 3'b000};
        4'b0101: data_out = {3'b000, data_in[63:3]};
        4'b0110: data_out = {data_in[59:0], 4'b0000};
        4'b0111: data_out = {4'b0000, data_in[63:4]};
        default: data_out = data_in;
    endcase
end

endmodule