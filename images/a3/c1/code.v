module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] reg1, reg2, reg3;

always @(posedge clk) begin
    if(load) begin
        reg1 <= data;
        reg2 <= reg1;
        reg3 <= reg2;
        q <= reg3;
    end else begin
        case(ena)
            2'b00: begin
                reg1 <= {reg1[98:0], reg1[99]};
                reg2 <= {reg2[98:0], reg2[99]};
                reg3 <= {reg3[98:0], reg3[99]};
                q <= reg3;
            end
            2'b01: begin
                reg1 <= {reg1[0], reg1[99:1]};
                reg2 <= {reg2[0], reg2[99:1]};
                reg3 <= {reg3[0], reg3[99:1]};
                q <= reg3;
            end
            2'b10: begin
                reg1 <= {reg1[0], reg1[99:1]};
                reg2 <= {reg2[0], reg2[99:1]};
                reg3 <= {reg3[0], reg3[99:1]};
                q <= reg3;
            end
            2'b11: begin
                reg1 <= {reg1[98:0], reg1[99]};
                reg2 <= {reg2[98:0], reg2[99]};
                reg3 <= {reg3[98:0], reg3[99]};
                q <= reg3;
            end
        endcase
    end
end

endmodule