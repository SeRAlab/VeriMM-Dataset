module binary_counter_7bit_with_enable_load(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [6:0] load_value,
    output reg [6:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 7'b0000000;
        end else if (load) begin
            count <= load_value;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule