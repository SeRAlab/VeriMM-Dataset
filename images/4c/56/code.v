module adder_4bit(a, b, cin, sum, cout);

    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] sum;
    output cout;
    reg [4:0] temp;

    always @(a or b or cin)
    begin
        temp = a + b + cin;
        sum = temp[3:0];
        cout = temp[4];
    end

endmodule