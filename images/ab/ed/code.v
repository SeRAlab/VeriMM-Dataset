module top_module(

    input wire        clock,        
    input wire [7:0]  d8_chr,
    output reg [13:0] addr,
    output reg [4:0]  r,
    output reg [5:0]  g,
    output reg [4:0]  b,
    output reg        hs,
    output reg        vs
);reg  [9:0] x;
reg  [9:0] y;
reg  [7:0] attr;
reg  [7:0] bit8;
reg  [7:0] mask;


wire [9:0] rx = x - 8'd48;
wire [9:0] ry = y - 8'd48;
wire       bitset = mask[ 3'h7 ^ rx[3:1] ];


always @(posedge clock) begin

    
    if (x == 10'd800) begin
    
        x <= 1'b0;
        y <= (y == 10'd525) ? 1'b0 : (y + 1'b1); 
        
    end else x <= x + 1'b1;
    
    
    hs <= (x >= 10'd656 && x <= 10'd751); 
    vs <= (y >= 10'd490 && y <= 10'd492); 
    
    
    
    if (x < 10'd640 && y < 10'd480) begin
    
        if (x >= 64 && x < 576 && y >= 48 && y < 432) begin
        
            r <= bitset? 1'b0 : 5'h0F; 
            g <= bitset? 1'b0 : 6'h1F;
            b <= bitset? 1'b0 : 5'h0F;
        
        
        end else begin r <= 5'h0F; g <= 6'h1F; b <= 5'h0F; end

    
    end else begin r <= 1'b0; g <= 1'b0; b <= 1'b0; end
    
    
    case (rx[3:0])
    
        
        4'h0: begin addr <= {2'b10, ry[8:1], rx[8:4]}; end 
        
        
        4'h1: begin addr <= {5'b10110, ry[8:4], rx[8:4]}; bit8 <= d8_chr; end 
        
        
        4'hF: begin attr <= d8_chr; mask <= bit8; end 

    endcase

end

endmodule