module deserializer (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [31:0] data_out
);

reg [2:0] count; // 3 bits to count 0-7
reg [31:0] buffer; // to hold the 32 bits

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 3'b000;
        buffer <= 32'b0;
        data_out <= 32'b0;
    end else begin
        buffer <= {buffer[27:0], data_in}; // shift left and insert new data_in
        if (count < 3'b111) begin
            count <= count + 1;
        end else begin
            data_out <= buffer; // output the final 32 bits after 8 cycles
        end
    end
end

endmodule