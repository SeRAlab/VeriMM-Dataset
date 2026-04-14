module top_module(
   op,
   a,
   b,
   y,
   cin,
   cout,
   zout
);input  [3:0]	op;	
input  [7:0]	a;	
input  [7:0]	b;	
output [7:0]	y;	
input		cin;
output		cout;
output		zout;




















reg		cout;
reg		zout;
reg [7:0]	y;


reg		addercout; 
 
parameter [3:0] ALUOP_ADD  = 4'b0000;
parameter [3:0] ALUOP_SUB  = 4'b1000;
parameter [3:0] ALUOP_AND  = 4'b0001;
parameter [3:0] ALUOP_OR   = 4'b0010;
parameter [3:0] ALUOP_XOR  = 4'b0011;
parameter [3:0] ALUOP_COM  = 4'b0100;
parameter [3:0] ALUOP_ROR  = 4'b0101;
parameter [3:0] ALUOP_ROL  = 4'b0110;
parameter [3:0] ALUOP_SWAP = 4'b0111;


always @(a or b or cin or op) begin
   case (op) 
      ALUOP_ADD:  {addercout,  y}  = a + b;
      ALUOP_SUB:  {addercout,  y}  = a - b; 
      ALUOP_AND:  {addercout,  y}  = {1'b0, a & b};
      ALUOP_OR:   {addercout,  y}  = {1'b0, a | b};
      ALUOP_XOR:  {addercout,  y}  = {1'b0, a ^ b};
      ALUOP_COM:  {addercout,  y}  = {1'b0, ~a};
      ALUOP_ROR:  {addercout,  y}  = {a[0], cin, a[7:1]};
      ALUOP_ROL:  {addercout,  y}  = {a[7], a[6:0], cin};
      ALUOP_SWAP: {addercout,  y}  = {1'b0, a[3:0], a[7:4]};
      default:    {addercout,  y}  = {1'b0, 8'h00};
   endcase
end

always @(y)
   zout = (y == 8'h00);

always @(addercout or op)
   if (op == ALUOP_SUB) cout = ~addercout; 
   else                 cout =  addercout;
      
endmodule