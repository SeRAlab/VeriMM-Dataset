module top_module(A, B, _EQL, _GT, _LT);input   [3:0]   A, B;
    output          _EQL, _GT, _LT;

    reg             _EQL, _GT, _LT;

    always@(A or B) begin
            _EQL = (A == B);
            _GT = (A > B);
            _LT = (A < B);
    end

endmodule