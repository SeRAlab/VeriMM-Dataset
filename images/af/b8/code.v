module top_module(
    input clk, reset, we_n,
    input [1:0] addr,
    input [7:0] idata,
    output reg [7:0] odata,
    output reg [7:0] opa,
    output reg [7:0] opb,
    output reg [7:0] opc
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        odata <= 8'h00;
        opa <= 8'hFF;
        opb <= 8'hFF;
        opc <= 8'hFF;
    end else begin
        case (addr)
            2'b00: odata <= opa;
            2'b01: odata <= opb;
            2'b10: odata <= opc;
            2'b11: odata <= 8'h00;
        endcase

        if (~we_n) begin
            case (addr)
                2'b00: opa <= idata;
                2'b01: opb <= idata;
                2'b10: opc <= idata;
                2'b11: begin
                    opc[idata[3:1]] <= idata[0];
                end
            endcase
        end
    end
end

endmodule