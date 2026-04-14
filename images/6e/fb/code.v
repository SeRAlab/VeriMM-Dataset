module shift_register_4bit(
    input  clk,
    input  rst,
    input  load,
    input  [3:0] data_in,
    output reg [3:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 4'b0000;
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= data_out << 1;
    end
end

endmodule