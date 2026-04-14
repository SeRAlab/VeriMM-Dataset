module hazard_detection (
    input wire a,
    input wire b,
    output wire hazard_detected,
    output wire resolved
);
    assign hazard_detected = a & b; // Hazard detected if both inputs are 1
    assign resolved = ~(a & b); // Hazard resolved if at least one input is 0
endmodule