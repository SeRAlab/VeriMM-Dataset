module fm_3d_fcnv (
  i_f32,
  o_f22
);
    input  [31:0] i_f32;
    output [21:0] o_f22;
    assign o_f22 = f_f32_to_f22(i_f32);
    function [21:0] f_f32_to_f22;
        input [31:0] f32;
        reg s;
        reg [7:0]  e8;
        reg [8:0]  e8d;  
        reg [4:0]  e5;
        reg [23:0] m23;
        reg [14:0] m15;
        reg        carry;
        reg        zf;
        begin
            s = f32[31];
            e8 = f32[30:23];
            zf = (e8 == 8'h00);
            m23 = f32[22:0];
            {carry,m15} = m23[22:8] + m23[7];
            e8d = e8 - 112 + carry;  
            if (zf|e8d[8]) begin
                e5 = 5'h0;
            end else begin
                e5 = e8d[4:0];
            end
            f_f32_to_f22 = {s,e5,!(zf|e8d[8]),m15};
        end
    endfunction
endmodule