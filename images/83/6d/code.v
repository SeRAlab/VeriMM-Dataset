module shift_register(
    input clk,
    input rst,
    input load,
    input left_right,
    input [7:0] data_in,
    input data_serial,
    output reg [7:0] data_out
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (left_right) begin
            data_out <= {data_out[6:0], data_serial};
        end else begin
            data_out <= {data_serial, data_out[7:1]};
        end
    end
endmodule