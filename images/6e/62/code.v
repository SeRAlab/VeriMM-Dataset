module top_module(resultID, newresult, done, reset, globalreset, clk);input[1:0] resultID; 
    input newresult; 
    output[1:0] done; 
    wire[1:0] done;
    input reset; 
    input globalreset; 
    input clk; 

    reg[3:0] count; 
    reg[1:0] curr; 

    assign done = (count == 0) ? curr : 2'b00 ;

    always @(posedge clk or posedge reset or posedge globalreset)
    begin
        if (globalreset)
        begin
            count <= 4'b1000;
            curr <= 2'b00;
        end
        else if (reset)
        begin
            count <= 4'b1000;
        end
        else if (newresult && resultID != 2'b00 && count != 0)
        begin
            count <= count - 1;
            curr <= resultID;
        end
        else if (count == 0)
        begin
            curr <= 2'b00;
        end
    end 
endmodule