module top_module(A, B, ZF, OF, F, ALU_OP);input [2:0] ALU_OP;
    input [31:0] A, B;
    output reg [31:0] F;
    output reg ZF, OF;
    reg C32;
    always @(*)
    begin
        case(ALU_OP)
            3'd0:begin 
                F = A&B;
                OF = 0;
            end
            3'd1:begin 
                F = A|B;
                OF = 0;
            end
            3'd2:begin 
                F = A^B;
                OF = 0;
            end
            3'd3:begin 
					 F = ~(A|B);
					 OF = 0;
				end
            3'd4:begin 
                {C32, F} = A + B;
                OF = A[31]^B[31]^F[31]^C32;
            end
            3'd5:begin 
                {C32, F} = A - B;
                OF = A[31]^B[31]^F[31]^C32;
            end
            3'd6:begin 
                if (A<B)
                    begin
                        F = 32'd1;
                    end
                else 
                    begin
                        F = 32'd0;
                    end
                OF = 0;
            end
            3'd7:begin 
              F=B<<A;
              OF=0;
            end
            default:begin
              F=A;
              OF = 0;
            end
            
        endcase
        if (F == 32'd0)
            begin
                ZF = 1;
            end
        else 
            begin
                ZF = 0;
            end
    end
    
endmodule