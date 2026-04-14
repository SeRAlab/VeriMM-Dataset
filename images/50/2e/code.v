module binary_adder_4bit (sum, cout, a, b, cin);
   input [3:0] a, b;
   input cin;
   output [3:0] sum;
   output cout;
   
   reg [4:0] temp_sum;

always @(*) begin
    temp_sum = a + b + cin;
    sum = temp_sum[3:0];
    cout = temp_sum[4];
end //End of always block
    
endmodule