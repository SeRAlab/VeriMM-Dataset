module sync_johnson_counter_8bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [7:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b00000000;
        end else if (en) begin
            count <= {count[6:0], ~count[7]};
        end
    end

endmodule