module deserializer (
    input clk,
    input reset,
    input din,
    input valid,
    output reg [7:0] dout
);
    reg [2:0] bit_count; // 3 bits to count up to 8

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 8'b0;
            bit_count <= 3'b0;
        end else if (valid) begin
            dout <= {dout[6:0], din}; // Shift in the new bit
            if (bit_count < 3'd7)
                bit_count <= bit_count + 3'd1;
            else
                bit_count <= 3'b0; // Reset after 8 bits
        end
    end
endmodule