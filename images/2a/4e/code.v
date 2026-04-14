module shift_register (
    input wire clk,
    input wire rst,
    input wire shift_left, // 1 for left shift, 0 for right shift
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000; // Reset the shift register
        end else begin
            if (shift_left) begin
                data_out <= {data_out[2:0], data_in[0]}; // Shift left
            end else begin
                data_out <= {data_in[3], data_out[3:1]}; // Shift right
            end
        end
    end
endmodule