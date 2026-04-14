module top_module(
  i_a,
  o_b
);input  [21:0] i_a;          
    output [7:0]  o_b;          



    
    wire        w_sign;
    wire [4:0]  w_exp;
    wire [15:0] w_fraction;




    assign w_sign = i_a[21];
    assign w_exp  = i_a[20:16];
    assign w_fraction = i_a[15:0];

    assign o_b = f_ftoi(w_exp, w_fraction);



    function [7:0] f_ftoi;
        input [4:0]  exp;
        input [15:0] frac;
        begin
            case (exp)
                5'd15: f_ftoi = {7'b0,frac[15]};
                5'd16: f_ftoi = {6'b0,frac[15:14]};
                5'd17: f_ftoi = {5'b0,frac[15:13]};
                5'd18: f_ftoi = {4'b0,frac[15:12]};
                5'd19: f_ftoi = {3'b0,frac[15:11]};
                5'd20: f_ftoi = {2'b0,frac[15:10]};
                5'd21: f_ftoi = {1'b0,frac[15:9]};
                5'd22: f_ftoi = frac[15:8];
                5'd23: f_ftoi = 8'd255;  
                default: f_ftoi = 8'h0;  
            endcase
        end
    endfunction

endmodule