module top_module(
    input CLK, RST, LD, UD,
    input [3:0] LOAD_IN,
    output reg [3:0] Q
);reg [3:0] Q1, Q2;

always @(posedge CLK) begin
    if(RST) begin
        Q1 <= 4'b0;
        Q2 <= 4'b0;
    end
    else if(LD) begin
        Q1 <= LOAD_IN;
        Q2 <= LOAD_IN;
    end
    else begin
        Q1 <= Q2;
        if(UD) begin
            Q2 <= Q2 + 4'b1;
        end
        else begin
            Q2 <= Q2 - 4'b1;
        end
    end
end

assign Q = Q1;

endmodule