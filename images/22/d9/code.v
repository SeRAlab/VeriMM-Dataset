module UpDownCounter (
    input clk,
    input rst,
    input up,
    input down,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000; // reset to 0
        end else if (up && !down) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // increment with wrap
        end else if (down && !up) begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // decrement with wrap
        end
    end
endmodule