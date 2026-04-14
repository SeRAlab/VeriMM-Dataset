`timescale 1ns/1ps

module sparc_ifu_cmp35_tb;

    // Testbench signals (combinational circuit)
    reg [34:0] a;
    reg [34:0] b;
    reg valid;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sparc_ifu_cmp35 dut (
        .a(a),
        .b(b),
        .valid(valid),
        .hit(hit)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sparc_ifu_cmp35 Testbench");
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
        input expected_hit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: hit=%b",
                         hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hit=%b",
                         expected_hit);
                $display("  Got:      hit=%b",
                         hit);
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
