module binary_counter_load_8bit(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] load_value,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 8'b00000000;
        end else if (load) begin
            count <= load_value;
        end else begin
            count <= count + 1;
        end
    end
endmodule