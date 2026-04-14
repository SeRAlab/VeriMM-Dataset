module top_module(
    input [3:0] data,
    input [2:0] shift,
    output reg [3:0] out  // Changed from wire to reg
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    stage1_out[0] = (shift[0] == 1) ? data[1] : data[0];
    stage1_out[1] = (shift[0] == 1) ? data[2] : data[1];
    stage1_out[2] = (shift[0] == 1) ? data[3] : data[2];
    stage1_out[3] = (shift[0] == 1) ? data[0] : data[3];
end

always @(*) begin
    stage2_out[0] = (shift[1] == 1) ? stage1_out[2] : stage1_out[0];
    stage2_out[1] = (shift[1] == 1) ? stage1_out[3] : stage1_out[1];
    stage2_out[2] = (shift[1] == 1) ? stage1_out[0] : stage1_out[2];
    stage2_out[3] = (shift[1] == 1) ? stage1_out[1] : stage1_out[3];
end

always @(*) begin
    if (shift[2] == 1) begin
        out[0] = stage2_out[1];
        out[1] = stage2_out[2];
        out[2] = stage2_out[3];
        out[3] = stage2_out[0];
    end else begin
        out = stage2_out; // Correct usage of reg type since out is declared as reg
    end
end

endmodule