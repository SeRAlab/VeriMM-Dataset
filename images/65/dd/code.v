module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg X,
    output reg Y
    );always @ (A or B or C or D)
        begin
            if (!((A & C) ^ (B & D)) == 1) 
                X = 1;
            else if ((~C) & (B | D) & C ^ !( B & D) == 1)
                X = 1;
            else
                X = 0;
            
            if ( !(A & ~C) == 1 )  
                Y = 1;
            else if ((D & (A ^ B) & C)  == 1)
                Y = 1;
            else if ((D & (~B | A)) == 1)
                Y = 1;
            else
                Y = 0;
        end
endmodule