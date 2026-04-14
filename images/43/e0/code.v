module top_module(
    input [Width-1:0] In,
    output reg Out
);parameter Parity = 0;
parameter Width = 8;

always @ (In) begin
    case (Parity)
        1: Out = ~^In; // odd parity
        2: Out = ^In; // even parity
        3: Out = 1; // always 1 parity
        4: Out = 0; // always 0 parity
        default: Out = 1'b0;
    endcase
end

endmodule