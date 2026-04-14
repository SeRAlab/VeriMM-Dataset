module dma_controller (
    input wire clk,
    input wire req1,
    input wire req2,
    output reg gnt1,
    output reg gnt2
);
    
    always @(posedge clk) begin
        if (req1) begin
            gnt1 <= 1;
            gnt2 <= 0;
        end else if (req2) begin
            gnt1 <= 0;
            gnt2 <= 1;
        end else begin
            gnt1 <= 0;
            gnt2 <= 0;
        end
    end

endmodule