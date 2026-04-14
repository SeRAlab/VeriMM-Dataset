module top_module(
    input [14:0] addr,
    input [2:0] ba,
    input cas_n,
    input ck_n,
    input ck_p,
    input cke,
    input cs_n,
    input [3:0] dm,
    input [31:0] dq,
    input [3:0] dqs_n,
    input [3:0] dqs_p,
    input odt,
    input ras_n,
    input reset_n,
    input we_n,
    output reg [7:0] led
);reg [31:0] data;
    reg [3:0] mask;
    
    always @ (cs_n or we_n or addr or ba or dq or mask or data) begin
        if(!cs_n) begin
            if(!we_n) begin
                case(ba)
                    3'b000: data[7:0] <= dq[7:0] & mask[0];
                    3'b001: data[7:0] <= dq[15:8] & mask[1];
                    3'b010: data[7:0] <= dq[23:16] & mask[2];
                    3'b011: data[7:0] <= dq[31:24] & mask[3];
                    default: data[7:0] <= 0;
                endcase
            end
            else begin
                led <= data[7:0];
            end
        end
    end
    
endmodule