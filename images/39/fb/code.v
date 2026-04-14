module divide_by_8 (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else begin
            data_out <= data_in >> 3; // Divide by 8 using right shift
        end
    end
endmodule