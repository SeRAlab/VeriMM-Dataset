module bidir_shift_register(
    input clk,
    input rst_n,
    input load,
    input dir,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 4'b0000;
        end else if (load) begin
            data_out <= data_in;
        end else if (dir) begin
            data_out <= {data_out[2:0], 1'b0};
        end else begin
            data_out <= {1'b0, data_out[3:1]};
        end
    end
endmodule