module top_module(
    input clk,
    input [7:0] in,
    output reg q
);reg [7:0] in_reg;
reg edge_detect, edge_detect_reg;
reg [1:0] flip_flop;
reg [3:0] counter;

always @(posedge clk) begin
    in_reg <= in;
    edge_detect_reg <= edge_detect;
    
    // Edge detector
    if (in_reg != in_reg[7:1]) begin
        edge_detect <= 1;
    end else begin
        edge_detect <= 0;
    end
    
    // Dual-edge triggered flip-flop
    if (edge_detect_reg == 1 && flip_flop == 0) begin
        flip_flop <= 1;
    end else if (edge_detect_reg == 1 && flip_flop == 1) begin
        flip_flop <= 0;
    end
    
    // Debounce counter
    if (flip_flop == 1 && counter < 4) begin
        counter <= counter + 1;
    end else if (flip_flop == 0) begin
        counter <= 0;
    end
    
    // Output
    if (counter == 4) begin
        q <= edge_detect & flip_flop;
    end
end

endmodule