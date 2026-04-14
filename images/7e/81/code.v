module up_down_counter(
    input clk,
    input rst,
    input en,
    input dir,

    output reg [4:0] count
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        count <= 5'b00000;     // reset
    else if (en)
    begin
        if (dir)
            count <= count + 1; // increment
        else
            count <= count - 1; // decrement
    end
end

endmodule