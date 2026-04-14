module ring_counter(
    input clk,
    input rst,
    input en,
    output reg [4:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 5'b00001;
        end else if (en) begin
            count <= {count[3:0], count[4]};
        end
    end
endmodule