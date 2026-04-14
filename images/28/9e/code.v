module ring_counter(
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [4:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b00001;
        end else if (enable) begin
            count <= {count[3:0], count[4]};
        end
    end
endmodule