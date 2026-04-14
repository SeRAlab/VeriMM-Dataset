module deserializer(
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] parallel_out
);
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'b000;
            parallel_out <= 8'b00000000;
        end else if (count < 3'b111) begin
            parallel_out <= {serial_in, parallel_out[7:1]};
            count <= count + 1;
        end
    end
endmodule