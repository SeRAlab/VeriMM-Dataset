module verified_binary_counter(clk, load, data, count);

    input clk;
    input load;
    input [3:0] data;
    output [3:0] count;
    reg [3:0] count;
    initial count = 0;

    always @(posedge clk)
        begin
            if (load)
                count <= data;
            else
                count <= count + 1;
        end

endmodule