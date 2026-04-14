module sync_binary_counter_8bit (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] max_limit,
    output reg [7:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b0;
        end else if (en) begin
            if (count == max_limit) begin
                count <= 8'b0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule