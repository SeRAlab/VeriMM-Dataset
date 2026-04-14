module temperature_sensor(
    input clk,
    input rst,
    input [9:0] temp_input,
    output reg [3:0] temp_output
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_output <= 4'b0000; // Reset output to 0
        end else begin
            case (temp_input)
                10'b0000000000: temp_output <= 4'b0000; // 0
                10'b0000000001: temp_output <= 4'b0000; // 1
                // ... (fill in all values from 1 to 100)
                10'b0000000110: temp_output <= 4'b0000; // 100
                // 101 - 200
                10'b0000000111: temp_output <= 4'b0001; // 101
                // ... (fill in all values from 101 to 200)
                10'b0000001100: temp_output <= 4'b0001; // 200
                // 201 - 300
                10'b0000001101: temp_output <= 4'b0010; // 201
                // ... (fill in all values from 201 to 300)
                10'b0000010010: temp_output <= 4'b0010; // 300
                // 301 - 400
                // ... (same for 301 - 400, 401 - 500, etc.)
                10'b0000010111: temp_output <= 4'b0011; // 400
                10'b0000011000: temp_output <= 4'b0100; // 401
                // ...
                10'b0011100111: temp_output <= 4'b1001; // 901
                10'b0011111111: temp_output <= 4'b1001; // 1023
                default: temp_output <= 4'b0000; // Default case
            endcase
        end
    end
endmodule