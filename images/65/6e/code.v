module sync_up_counter_8bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [7:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b0;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule