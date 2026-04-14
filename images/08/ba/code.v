module shift_register (
    input wire clk,
    input wire rst,
    input wire dir, // 0 for left shift, 1 for right shift
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 16'b0;
    end else begin
        if (dir == 1'b0) begin // left shift
            data_out <= {data_out[14:0], data_in[15]};
        end else begin // right shift
            data_out <= {data_in[0], data_out[15:1]};
        end
    end
end

endmodule