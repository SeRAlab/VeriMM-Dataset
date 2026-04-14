module johnson_counter_4bit(
    input wire clk,
    input wire rst,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0000;
        end else begin
            count <= {~count[0], count[3:1]};
        end
    end
endmodule