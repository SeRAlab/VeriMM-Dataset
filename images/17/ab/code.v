module bluetooth_status_checker(
    input wire power_on,
    input wire connected,
    output wire status
);
    assign status = power_on & connected; // Active if both conditions are true
endmodule