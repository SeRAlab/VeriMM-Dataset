module Mux (
    input A,
    input B,
    input sel,
    output Y
);

assign Y = sel ? B : A;

endmodule