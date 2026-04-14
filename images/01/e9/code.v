module timer_16bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
        end else if (enable) begin
            if (count == 16'hFFFF) begin
                count <= 16'b0; // Roll over
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule