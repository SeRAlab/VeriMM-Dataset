module top_module(
    input clk,
    input rst_n,
    input Cal_Valid,
    input signed [7:0]  weight,
    input signed [31:0] data,
    output reg signed [31:0] Dout
);reg  [31:0] buffer ;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            Dout <= 0;
            buffer <= 0;
        end
        else begin
            if(Cal_Valid)begin
                buffer <= weight * data;
                Dout   <= buffer + Dout;
            end
            else begin
                Dout   <= 0;
                buffer <= 0;
            end
        end
    end

endmodule