module wifi_signal_indicator (
    input wire clk,
    input wire [7:0] signal_strength,
    output reg [2:0] strength_category
);
    
    always @(posedge clk) begin
        if (signal_strength <= 84) begin
            strength_category <= 3'b000; // weak
        end else if (signal_strength <= 169) begin
            strength_category <= 3'b001; // moderate
        end else begin
            strength_category <= 3'b010; // strong
        end
    end
endmodule