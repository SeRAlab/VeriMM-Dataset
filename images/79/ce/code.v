module down_counter (
    input wire clk,
    input wire rst,
    output reg [2:0] count
);
    
    always @(posedge clk) begin
        if (rst) begin
            count <= 3'b111;
        end else begin
            count <= count - 1;
        end
    end

endmodule