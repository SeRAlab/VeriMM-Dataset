module top_module( i,
 D,
 Q);input [4-1:0] i;
input [16:0] D;
output [16:0] Q;
reg    [16:0] Q;


  always @ (D or i) begin
    
    
    case (i)
      0: begin
        Q[16-0:0] = D[16: 0];
        
      end
      1: begin
        Q[16-1:0] = D[16: 1];
        Q[16:16-1+1] = 1'b0;
      end
      2: begin
        Q[16-2:0] = D[16: 2];
        Q[16:16-2+1] = 2'b0;
      end
      3: begin
        Q[16-3:0] = D[16: 3];
        Q[16:16-3+1] = 3'b0;
      end
      4: begin
        Q[16-4:0] = D[16: 4];
        Q[16:16-4+1] = 4'b0;
      end
      5: begin
        Q[16-5:0] = D[16: 5];
        Q[16:16-5+1] = 5'b0;
      end
      6: begin
        Q[16-6:0] = D[16: 6];
        Q[16:16-6+1] = 6'b0;
      end
      7: begin
        Q[16-7:0] = D[16: 7];
        Q[16:16-7+1] = 7'b0;
      end
      8: begin
        Q[16-8:0] = D[16: 8];
        Q[16:16-8+1] = 8'b0;
      end
      9: begin
        Q[16-9:0] = D[16: 9];
        Q[16:16-9+1] = 9'b0;
      end
      10: begin
        Q[16-10:0] = D[16:10];
        Q[16:16-10+1] = 10'b0;
      end
      11: begin
        Q[16-11:0] = D[16:11];
        Q[16:16-11+1] = 11'b0;
      end
      12: begin
        Q[16-12:0] = D[16:12];
        Q[16:16-12+1] = 12'b0;
      end
      13: begin
        Q[16-13:0] = D[16:13];
        Q[16:16-13+1] = 13'b0;
      end
      14: begin
        Q[16-14:0] = D[16:14];
        Q[16:16-14+1] = 14'b0;
      end
      15: begin
        Q[16-15:0] = D[16:15];
        Q[16:16-15+1] = 15'b0;
      end
    endcase
  end
endmodule