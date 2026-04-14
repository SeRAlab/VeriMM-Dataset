module timer_16bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [15:0] data_in,
    output reg [15:0] count,
    output reg done
);
    parameter MAX = 16'hFFFF; // Max value for 16-bit

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0;
            done <= 1'b0;
        end else if (load) begin
            count <= data_in;
            done <= (data_in >= MAX) ? 1'b1 : 1'b0;
        end else begin
            if (count < MAX) begin
                count <= count + 1;
            end
            done <= (count >= MAX) ? 1'b1 : 1'b0;
        end
    end
endmodule