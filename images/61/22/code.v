module sync_up_counter_with_reset (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [5:0] count
);
    
    always @(posedge clk) begin
        if (rst) begin
            count <= 6'b000000;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule