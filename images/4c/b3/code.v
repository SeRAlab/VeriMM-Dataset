module top_module(
    input clk, reset_n, enable, load,
    input [3:0] data_in,
    output reg [3:0] data_out
);reg [3:0] counter;
    
    always @(posedge clk) begin
        if (reset_n == 1'b0) begin
            counter <= 4'b0;
        end
        else if (enable == 1'b1) begin
            if (load == 1'b1) begin
                counter <= data_in;
            end
            else if (counter == 4'hF) begin
                counter <= 4'b0;
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end
    
    assign data_out = counter;
    
endmodule