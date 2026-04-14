module top_module(
                      input [WIDTH-1:0] data_in, 
                      input write, 
                      input clk, 
                      input reset,
                      output reg [WIDTH-1:0] data_out
                    );parameter WIDTH = 8; // default parameter of the register width
parameter RESET_VALUE = 0;

always @(posedge clk) begin
    if(reset) begin
        data_out <= RESET_VALUE;
    end
    else if(write) begin
        data_out <= data_in;
    end
end

endmodule