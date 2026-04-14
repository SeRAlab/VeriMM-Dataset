module sync_up_counter_16bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [15:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0000000000000000;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule