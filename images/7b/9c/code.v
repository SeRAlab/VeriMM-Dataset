module top_module(clk, data_in, shamt, fnc, data_out);input clk;
    input [31:0] data_in;
    input [4:0] shamt;
    input [1:0] fnc;
    output reg [31:0] data_out;

    always @(posedge clk) begin
        case (fnc)
            2'b00: data_out <= data_in << shamt; // sll
            2'b01: data_out <= data_in >> shamt; // slr
            2'b10: begin // sar
                if (data_in[31] == 1) begin
                    data_out <= ~(32'hFFFFFFFF >> shamt) | (data_in >> shamt);
                end else begin
                    data_out <= data_in >> shamt;
                end
            end
            default: data_out <= 32'hxxxxxxxx;
        endcase
    end

endmodule