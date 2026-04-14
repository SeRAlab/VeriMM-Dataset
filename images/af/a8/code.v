module top_module(output wire [3:0]sum, carry_ahead,
                        input wire [3:0] a, b,
                        input wire c_in
    
);assign carry_ahead[0]= ((a[0]&b[0]) | (c_in&(a[0]^b[0])));
    assign carry_ahead[1]= ((a[1]&b[1]) | ((a[1]^b[1])&carry_ahead[0]));
    assign carry_ahead[2]= ((a[2]&b[2]) | ((a[2]^b[2])&carry_ahead[1]));
    assign carry_ahead[3]= ((a[3]&b[3]) | ((a[3]^b[3])&carry_ahead[2]));

    assign sum[0]= (a[0]^b[0]^c_in);
    assign sum[1]= (a[1]^b[1]^carry_ahead[0]);
    assign sum[2]= (a[2]^b[2]^carry_ahead[1]);
    assign sum[3]= (a[3]^b[3]^carry_ahead[2]);

endmodule