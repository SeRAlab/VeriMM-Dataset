module mux_4to1(
    input        enable,
    input  [1:0] sel,
    input  [7:0] data0,
    input  [7:0] data1,
    input  [7:0] data2,
    input  [7:0] data3,
    output reg [7:0] data_out
);

// Multiplexer logic
always @(*) begin
    if (enable) begin
        case (sel)
            2'b00: data_out = data0;
            2'b01: data_out = data1;
            2'b10: data_out = data2;
            2'b11: data_out = data3;
            default: data_out = 8'h00;
        endcase
    end else
        data_out = 8'h00;
end

endmodule