module ring_counter (
    input clk,
    input rst,
    output reg [4:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 5'b00001; // initialize to 00001
        end else begin
            out <= {out[3:0], out[4]}; // shift left and wrap around
        end
    end
endmodule