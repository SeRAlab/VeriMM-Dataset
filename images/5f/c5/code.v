module top_module(
    clk, reset, i_data, i_valid, o_stall, o_data, o_valid, i_stall
);parameter WIDTH=32;



input clk;
input reset;


input [WIDTH-1:0] i_data;
input i_valid;
output o_stall;


output [WIDTH-1:0] o_data;
output o_valid;
input i_stall;


reg [WIDTH-1:0] r_data;
reg r_valid;


assign o_stall = r_valid;


assign o_data = (r_valid) ? r_data : i_data;
assign o_valid = (r_valid) ? r_valid : i_valid;


always@(posedge clk or posedge reset)
begin
    if(reset == 1'b1)
    begin
        r_valid <= 1'b0;
        r_data <= 'x;   
    end
    else
    begin
        if (~r_valid) r_data <= i_data;
        r_valid <= i_stall && (r_valid || i_valid);
    end
end

endmodule