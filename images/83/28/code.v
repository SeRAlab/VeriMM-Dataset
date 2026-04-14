module shift_register_4bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [3:0] data_in,
    input wire shift_en,
    output reg [3:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0;
        end else if (load) begin
            data_out <= data_in;
        end else if (shift_en) begin
            data_out <= {data_out[2:0], 1'b0};
        end
    end

endmodule