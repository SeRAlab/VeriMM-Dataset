module up_down_counter_16bit (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire up_down,
    output reg [15:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0;
        end else if (enable) begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule