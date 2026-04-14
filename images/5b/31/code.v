module top_module(
    input [7:0] in,
    output reg out
);integer i;
    reg [7:0] temp_in;
    reg [3:0] temp_out;
    
    always @(*) begin
        temp_in = in;
        temp_out = {temp_in[0],temp_in[1],temp_in[2],temp_in[3]} ^ {temp_in[4],temp_in[5],temp_in[6],temp_in[7]};
        temp_out = temp_out ^ {temp_out[0],temp_out[1],temp_out[2],temp_out[3]};
        out = ~temp_out[0];
    end
endmodule