module reset_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] in_data,
    output reg [3:0] out_data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_data <= 4'b0000; // Reset output to 0
        end else begin
            out_data <= in_data; // Follow input data
        end
    end
endmodule