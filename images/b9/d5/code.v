module top_module(
    input [7:0] x,
    output reg z
    );task calc_even_parity;
        input [7:0] x;
        output z;
        begin
            z = x[7]^x[6]^x[5]^x[4]^x[3]^x[2]^x[1]^x[0];
        end
    endtask
    always
        @ (x)
        begin
            calc_even_parity(x,z);
        end
        
endmodule