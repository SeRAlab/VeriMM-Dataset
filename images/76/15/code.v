module shift_register_8bit_with_load(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] load_value,
    input wire shift_dir,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b00000000;
        end else if (load) begin
            q <= load_value;
        end else if (shift_dir) begin
            q <= {q[6:0], 1'b0};  // Left shift
        end else begin
            q <= {1'b0, q[7:1]};  // Right shift
        end
    end
endmodule