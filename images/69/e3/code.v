module lfsr (
    input clk,
    input areset,
    input en,
    output reg [11:0] count);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            count <= 12'b1;
        end else if (en) begin
            count <= {count[10:0], count[11] ^ count[3]}; 
        end
    end
endmodule