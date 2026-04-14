module timer_32bit (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [31:0] max_value,
    output reg [31:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 32'b0;
        end else if (en) begin
            if (count == max_value) begin
                count <= 32'b0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule