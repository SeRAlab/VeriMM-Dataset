module top_module(
    input [3:0] D,
    input clk, // Add missing clock input
    output A,
    output B,
    output C,
    output D_out, // Rename output D to D_out to avoid naming conflict
    output E,
    output F,
    output G
);reg [6:0] segment_data [0:15];
reg [3:0] pipeline_reg;
reg [6:0] pipeline_data [0:3];

assign A = pipeline_data[0][6];
assign B = pipeline_data[0][5];
assign C = pipeline_data[0][4];
assign D_out = pipeline_data[0][3]; // Change D to D_out
assign E = pipeline_data[0][2];
assign F = pipeline_data[0][1];
assign G = pipeline_data[0][0];

always @(*) begin
    segment_data[0] = 7'b1111110; // Default value for segment_data[0]
    case (D)
        4'b0000: segment_data[0] = 7'b1111110;
        4'b0001: segment_data[1] = 7'b0110000;
        4'b0010: segment_data[2] = 7'b1101101;
        4'b0011: segment_data[3] = 7'b1111001;
        4'b0100: segment_data[4] = 7'b0110011;
        4'b0101: segment_data[5] = 7'b1011011;
        4'b0110: segment_data[6] = 7'b1011111;
        4'b0111: segment_data[7] = 7'b1110000;
        4'b1000: segment_data[8] = 7'b1111111;
        4'b1001: segment_data[9] = 7'b1111011;
        4'b1010: segment_data[10] = 7'b1110111;
        4'b1011: segment_data[11] = 7'b0011111;
        4'b1100: segment_data[12] = 7'b1001110;
        4'b1101: segment_data[13] = 7'b0111101;
        4'b1110: segment_data[14] = 7'b1001111;
        4'b1111: segment_data[15] = 7'b1000111;
        default: segment_data[0] = 7'b1111110;
    endcase
end

always @(posedge clk) begin
    pipeline_data[0] <= segment_data[pipeline_reg];
    pipeline_data[1] <= pipeline_data[0];
    pipeline_data[2] <= pipeline_data[1];
    pipeline_data[3] <= pipeline_data[2];
    pipeline_reg <= D;
end

endmodule