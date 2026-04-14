module up_counter (
    input wire clk,
    input wire rstn,
    input wire en,
    output reg [3:0] count
);
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count <= 4'b0000;
        end else if (en) begin
            count <= count + 1'b1;
        end
    end
    
endmodule