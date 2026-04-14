module top_module(select, in0, in1, out);input select;
    input [4:0]in0, in1;
    output [4:0]out;
    reg [4:0]out;

    always @ (*)  begin
        if (select == 1'b0)    out <= in0;
        else    out <= in1; 
    end
endmodule