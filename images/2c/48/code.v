module mux4to1 (
    input [7:0] data0,
    input [7:0] data1,
    input [7:0] data2,
    input [7:0] data3,
    input [1:0] select,
    output reg [7:0] output_data
);

always @(*) begin
    case (select)
        2'b00: output_data = data0;
        2'b01: output_data = data1;
        2'b10: output_data = data2;
        2'b11: output_data = data3;
        default: output_data = 8'b00000000; // Default case
    endcase
end

endmodule