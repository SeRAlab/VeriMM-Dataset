module top_module( 
    input [99:0] a, b,
    input cin,
    input [299:0] data_in,
    input [1:0] select,
    output cout,
    output [199:0] sum );// 4:1 Multiplexer
    wire [99:0] selected_data;
    assign selected_data = (select == 2'b00) ? data_in[99:0] :
                           (select == 2'b01) ? data_in[199:100] :
                           (select == 2'b10) ? data_in[299:200] :
                           100'b0;
    
    // Carry-Lookahead Adder
    wire [99:0] carry;
    wire [99:0] s;
    
    assign carry[0] = cin;
    assign s[0] = a[0] ^ b[0] ^ cin;
    
    genvar i;
    generate
        for (i = 1; i < 100; i = i + 1) begin : cla_loop
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            assign s[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate
    
    assign cout = carry[99];
    
    // Additional Functional Module
    wire [199:0] sum_temp;
    assign sum_temp = (select == 2'b11) ? selected_data + 100'b0 :
                      selected_data + {100'b0, 1'b0};
    assign sum = sum_temp + s;
    
endmodule