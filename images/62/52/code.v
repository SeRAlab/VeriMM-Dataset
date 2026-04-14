module top_module(a_in, b_in, alu_function, c_alu);input  [31:0] a_in        ;
   input  [31:0] b_in        ;
   input  [ 3:0] alu_function;
   output [31:0] c_alu       ;

   wire [32:0] aa      ;
   wire [32:0] bb      ;
   wire [32:0] sum     ;
   wire        do_add  ;
   wire        sign_ext;

   assign do_add   = (alu_function == 4'b0001) ? 1'b1 : 1'b0 ; // alu_add
   assign sign_ext = (alu_function == 4'b0010) ? 1'b0 : 1'b1 ; // alu_less_than
   assign aa       = {(a_in[31] & sign_ext), a_in} ;
   assign bb       = {(b_in[31] & sign_ext), b_in} ;

   reg [31:0] c_alu;
   always @(*) begin
        case(alu_function)
            4'b0001 : c_alu = sum[31:0]         ; // alu_add
            4'b0010 : c_alu = {31'b0, sum[32]}  ; // alu_less_than
            4'b0100 : c_alu = a_in | b_in       ; // alu_or
            4'b0101 : c_alu = a_in & b_in       ; // alu_and
            4'b0110 : c_alu = a_in ^ b_in       ; // alu_xor
            4'b0111 : c_alu = ~(a_in | b_in)    ; // alu_nor
            default : c_alu = 32'b0             ; // alu_nothing
        endcase
    end

   assign sum = (do_add)? aa+bb : aa-bb;

endmodule