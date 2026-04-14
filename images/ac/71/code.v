module top_module(in, clk, rst, out);input wire in, clk, rst;
    output wire[3: 0] out;
    reg[3: 0] _out;

    always @(posedge clk) begin
        if (rst) begin
            _out <= 4'b0000;
        end else if (in) begin
            _out <= _out + 1;
        end else begin
            _out <= _out - 1;
        end
    end

    assign out = _out;
endmodule