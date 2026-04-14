module binary_counter_12bit_with_load(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [11:0] data,
    output reg [11:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 12'b000000000000;
        end else if (load) begin
            count <= data;
        end else begin
            count <= count + 1;
        end
    end
endmodule