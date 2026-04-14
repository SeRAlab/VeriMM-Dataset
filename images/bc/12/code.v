module mux_16to1_8bit (
    input wire [3:0] sel,
    input wire [127:0] data_in,
    output reg [7:0] data_out
    );

always @(*) begin
    case (sel)
        4'b0000: data_out = data_in[7:0];
        4'b0001: data_out = data_in[15:8];
        4'b0010: data_out = data_in[23:16];
        4'b0011: data_out = data_in[31:24];
        4'b0100: data_out = data_in[39:32];
        4'b0101: data_out = data_in[47:40];
        4'b0110: data_out = data_in[55:48];
        4'b0111: data_out = data_in[63:56];
        4'b1000: data_out = data_in[71:64];
        4'b1001: data_out = data_in[79:72];
        4'b1010: data_out = data_in[87:80];
        4'b1011: data_out = data_in[95:88];
        4'b1100: data_out = data_in[103:96];
        4'b1101: data_out = data_in[111:104];
        4'b1110: data_out = data_in[119:112];
        4'b1111: data_out = data_in[127:120];
        default: data_out = 8'b00000000;
    endcase
end

endmodule