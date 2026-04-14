module top_module(
    input [3:0] data,
    input shift,
    input load,
    output [3:0] shifted_data
);reg [3:0] register;

always @ (posedge shift or posedge load)
begin
    if (load) // Load input is high
        register <= data;
    else if (shift) // Shift input is high
        register <= {register[2:0], register[3]};
end

assign shifted_data = register;

endmodule