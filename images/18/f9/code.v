module simple_des (
    input [7:0] data_in,
    input [3:0] key,
    input clk,
    output reg [7:0] data_out
);
    
    always @(posedge clk) begin
        data_out <= {data_in[6:0], data_in[7]} ^ {key, 4'b0000};
    end
    
endmodule