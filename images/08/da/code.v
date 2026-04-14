module mux_32bit (
    input [31:0] data_in0,
    input [31:0] data_in1,
    input sel,
    output reg [31:0] data_out
);

always @(*) begin
    case(sel)
        1'b0: data_out = data_in0;
        1'b1: data_out = data_in1;
        default: data_out = 32'b0; // Default case
    endcase
end

endmodule