module top_module(
    input [3:0] x,y,
    output reg [3:0] z,
    output reg cout
    );task add_two_values;
        input [3:0] x,y;
        output [3:0] z;
        output cout;
        reg [4:0] k;
        begin
            {cout,z} = x + y;
        end
    endtask
    always
        @(x or y)
        begin
            add_two_values(x,y,z,cout);
        end
        
endmodule