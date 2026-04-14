module top_module(
    output reg[3:0] count,
    
    input Clock,
    input Clear,
    input Enable,
    input Load
    );wire Q;
    wire cnt_done;
    assign cnt_done = (count==4'b0000)?1:0;
    assign Q = count;
    
    always @ (posedge Clock)
        if(Clear)
            count <= 0;
        else if (Enable)
            if(Load | cnt_done)
                count <= 4'd10;
            else
            count <= count - 1;
endmodule