module mux_2_to_1 (
    input [15:0] data0,
    input [15:0] data1,
    input sel,
    output reg [15:0] data_out
);

always @(*) begin
    case (sel)
        1'b0: data_out = data0;
        1'b1: data_out = data1;
        default: data_out = 16'b0; // Default case (not strictly necessary)
    endcase
end

endmodule