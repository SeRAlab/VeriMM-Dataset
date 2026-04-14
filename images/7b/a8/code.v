module top_module(
Ball_X,
Ball_Y,
VGA_X,
VGA_Y,
Ball_S,
VGA_R,
VGA_G,
VGA_B);input [9:0] Ball_X;
input [9:0] Ball_Y;
input [9:0] VGA_X;
input [9:0] VGA_Y;
input [9:0] Ball_S;
output reg [9:0] VGA_R;
output reg [9:0] VGA_G;
output reg [9:0] VGA_B;


(*keep*)wire Ball_Show;
wire [19:0] Delta_X2,Delta_Y2,R2;

assign Delta_X2 = (VGA_X-Ball_X)*(VGA_X-Ball_X);
assign Delta_Y2 = (VGA_Y-Ball_Y)*(VGA_Y-Ball_Y);
assign R2       = (Ball_S*Ball_S);
assign Ball_Show = (Delta_X2+Delta_Y2)<= R2?1'b1:1'b0;



always@(Ball_Show, VGA_X, VGA_Y)
begin
   if(Ball_Show)
   begin
     VGA_R <= {10{1'b1}};
     VGA_G <= {10{1'b1}};
     VGA_B <= {10{1'b1}};
   end
   else
   begin 
     VGA_R <= {1'b0,VGA_X[4:0],{4{1'b1}}};
     VGA_G <= {1'b0,VGA_Y[5:0],{3{1'b1}}};
     VGA_B <= {1'b0,VGA_X[9:1]};
   end
end

endmodule