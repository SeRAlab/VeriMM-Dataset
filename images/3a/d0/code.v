module hash_table (
    input clk,
    input reset,
    input [7:0] key_in,
    input [7:0] value_in,
    input insert,
    input retrieve,
    output reg [7:0] value_out,
    output reg valid
);
    reg [7:0] keys [0:15];
    reg [7:0] values [0:15];
    reg [3:0] index;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                keys[i] <= 8'b0;
                values[i] <= 8'b0;
            end
            valid <= 0;
            value_out <= 8'b0;
        end else begin
            if (insert) begin
                index <= key_in % 16;
                keys[index] <= key_in;
                values[index] <= value_in;
            end
            if (retrieve) begin
                index <= key_in % 16;
                if (keys[index] == key_in) begin
                    value_out <= values[index];
                    valid <= 1;
                end else begin
                    value_out <= 8'b0;
                    valid <= 0;
                end
            end
        end
    end
endmodule