module hazard_detection (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
    wire AB, BC, AC; // Intermediate signals for the product terms

    assign AB = A & B; // Product term for A and B
    assign BC = B & C; // Product term for B and C
    assign AC = A & C; // Product term for A and C

    // Resolve hazards by ensuring stable outputs
    assign Y = (AB | BC | AC);

endmodule