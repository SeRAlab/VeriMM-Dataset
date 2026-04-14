module shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [1:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 2'b00; // reset output to 00
        end else begin
            data_out <= {data_out[0], serial_in}; // shift left and input new bit
        end
    end
endmodule