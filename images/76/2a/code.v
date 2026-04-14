module top_module(
    input [5:0] bin_val,
    output [3:0] bcd0, bcd1 
    );integer i;
    reg [7:0] bcd;
    
    always @(bin_val)
    begin
        bcd = 0;
        for (i = 0; i < 6; i = i + 1) 
        begin
            bcd = {bcd[6:0], bin_val[5-i]};
            if (i < 5 && bcd[3:0] > 4)
                bcd[3:0] = bcd[3:0] + 3;
            if (i < 5 && bcd[7:4] > 4)
                bcd[7:4] = bcd[7:4] + 3; 
        end
    end
    
    assign bcd0 = bcd[7:4];
    assign bcd0 = bcd[3:0];
    
endmodule