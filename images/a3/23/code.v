module top_module(
    input CLK, RESET, UP_DOWN, SELECT,
    input [3:0] in,
    output reg [3:0] Q,
    output parity
);reg [3:0] count;
reg parity_bit;

always @(posedge CLK) begin
    if(RESET) begin
        count <= 4'b0000;
        parity_bit <= 1'b0;
    end
    else begin
        if(UP_DOWN) begin
            count <= count + 1;
        end
        else begin
            count <= count - 1;
        end
        
        parity_bit <= ^count;
    end
end

always @(posedge CLK) begin
    if(RESET) begin
        Q <= 4'b0000;
    end
    else begin
        if(SELECT) begin
            Q <= count;
        end
        else begin
            Q <= {3'b000, parity_bit};
        end
    end
end

endmodule