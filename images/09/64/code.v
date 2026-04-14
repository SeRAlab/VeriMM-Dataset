module shift_register (
    input clk,
    input rst,
    input load,
    input shift_dir, // 0 for right shift, 1 for left shift
    input [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            if (shift_dir) begin
                data_out <= {data_out[2:0], 1'b0}; // Left shift
            end else begin
                data_out <= {1'b0, data_out[3:1]}; // Right shift
            end
        end
    end
endmodule