module instruction_pipeline (
    input wire clk,
    input wire reset,
    input wire [15:0] instruction_in,
    output reg [15:0] fetch_out,
    output reg [15:0] decode_out,
    output reg [15:0] execute_out,
    output reg [15:0] memory_out,
    output reg [15:0] write_back_out
);

reg [15:0] instruction_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fetch_out <= 16'b0;
        decode_out <= 16'b0;
        execute_out <= 16'b0;
        memory_out <= 16'b0;
        write_back_out <= 16'b0;
    end else begin
        fetch_out <= instruction_in;
        decode_out <= fetch_out;
        execute_out <= decode_out;
        memory_out <= execute_out;
        write_back_out <= memory_out;
    end
end

endmodule