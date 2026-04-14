module top_module(
    input main_clk,
    input [29:0]new_frequency,
    input reset,
    output reg new_clk
    );reg [29:0]counter;
    
    always @(posedge main_clk or posedge reset) begin 
        if (reset) begin
            new_clk <= 0;
            counter <= 0;
        end
        else begin
            if (counter < ((new_frequency - 1)/2)) begin
                counter <= counter + 1;
            end
            else begin
                counter <= 0;
                new_clk = (~new_clk);
            end
        end
    end 
    
endmodule