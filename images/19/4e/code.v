module hash_table(
    input clk,
    input rst,
    input [3:0] key,
    input [7:0] value,
    input insert,
    input retrieve,
    output reg [7:0] out_value,
    output reg found
);
    parameter SIZE = 16;
    reg [3:0] keys[0:SIZE-1];
    reg [7:0] values[0:SIZE-1];
    reg [3:0] head[0:SIZE-1];
    integer i;

    // Hash Function
    function [3:0] hash;
        input [3:0] key_in;
        hash = key_in % SIZE;
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                keys[i] <= 4'b0;
                values[i] <= 8'b0;
                head[i] <= 4'b0;
            end
            out_value <= 8'b0;
            found <= 0;
        end else begin
            if (insert) begin
                i = hash(key);
                keys[i] <= key;
                values[i] <= value;
                head[i] <= 1; // Indicate that an entry exists
            end
            if (retrieve) begin
                i = hash(key);
                if (head[i] == 1) begin
                    out_value <= values[i];
                    found <= 1;
                end else begin
                    out_value <= 8'b0;
                    found <= 0;
                end
            end
        end
    end
endmodule