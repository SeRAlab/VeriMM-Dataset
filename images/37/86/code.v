module deserializer (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [31:0] data_out
);
    reg [2:0] count; // 3-bit counter for 8 cycles
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            data_out <= 32'b0;
        end else if (count < 3'b111) begin
            data_out <= {data_out[27:0], data_in}; // shift in new data
            count <= count + 1;
        end else begin
            count <= 3'b111; // hold at 8 cycles
        end
    end
endmodule