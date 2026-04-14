module top_module(
    input Clock,Enable,Clear,Load,
    output [3:0] Q
    );reg [3:0] count;
    wire cnt_done;
    assign cnt_done = ~| count;
    assign Q = count;
    always @(posedge Clock)
    if (Clear)
    begin
        count <= 0;
    end
    else if (Enable)
    begin
        if (Load | cnt_done)
        count <= 4'b1010;   
        else
        count <= count - 1;
    end
endmodule