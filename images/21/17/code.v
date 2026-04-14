module serializer (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire start,
    output reg serial_out,
    output reg done
);
    reg [4:0] bit_index; // To keep track of which bit to send

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 5'd0;
            serial_out <= 1'b0;
            done <= 1'b0;
        end else if (start) begin
            if (bit_index < 5'd32) begin
                serial_out <= data_in[31 - bit_index]; // Send MSB first
                bit_index <= bit_index + 1;
                done <= 1'b0;
            end else begin
                done <= 1'b1;
            end
        end
    end
endmodule