module top_module(Clear, Timeout, CLOCK);input Clear, CLOCK;
    output reg Timeout;
    parameter COUNT_MAX = 100; //change this value to change the delay time
    
    reg [7:0] count;
    
    always @(posedge CLOCK) begin
        if(Clear) begin
            count <= 0;
            Timeout <= 0;
        end
        else begin
            if(count == COUNT_MAX) begin
                count <= 0;
                Timeout <= 1;
            end
            else begin
                count <= count + 1;
                Timeout <= 0;
            end
        end
    end
endmodule