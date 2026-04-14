module top_module(
    input Clock,
    input Clear,
    input Enable,
    input Load,
    output [3:0] Q
    );reg [3:0] count;
    wire cnt_done;  
    
    assign cnt_done = ~|count;   
    assign Q = count;
    
    always @(posedge Clock) begin
        if (Clear) count <= 4'b0000;
        else if (Enable)
            if (Load | cnt_done) count <= 4'b1010;
            else count <= count - 1;
    end
endmodule