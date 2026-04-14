`timescale 1ns/1ps

module zzecc_exu_chkecc2_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] d;
    reg [7:0] p;
    reg vld;
    wire ce;
    wire ne;
    wire [6:0] q;
    wire ue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzecc_exu_chkecc2 dut (
        .d(d),
        .p(p),
        .vld(vld),
        .ce(ce),
        .ne(ne),
        .q(q),
        .ue(ue)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzecc_exu_chkecc2 Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_ce;
        input expected_ne;
        input [6:0] expected_q;
        input expected_ue;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ce === (expected_ce ^ ce ^ expected_ce) &&
                expected_ne === (expected_ne ^ ne ^ expected_ne) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_ue === (expected_ue ^ ue ^ expected_ue)) begin
                $display("PASS");
                $display("  Outputs: ce=%b, ne=%b, q=%h, ue=%b",
                         ce, ne, q, ue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce=%b, ne=%b, q=%h, ue=%b",
                         expected_ce, expected_ne, expected_q, expected_ue);
                $display("  Got:      ce=%b, ne=%b, q=%h, ue=%b",
                         ce, ne, q, ue);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
