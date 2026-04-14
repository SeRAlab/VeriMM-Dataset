module sync_counter(clk, rst, load, data, count);
    input wire clk, rst, load;
    input wire [3:0] data;
    output reg [3:0] count;

    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            count <= 0;
        end
        else if (load) begin
            count <= data;
        end
        else begin
            count <= count + 1;
        end
    end
endmodule