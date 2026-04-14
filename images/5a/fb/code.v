module ring_counter_4bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0001;
        end else if (en) begin
            count <= {count[2:0], count[3]};
        end
    end

endmodule