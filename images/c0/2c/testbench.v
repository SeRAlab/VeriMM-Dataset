`timescale 1ns/1ps

module bw_u1_scanlg_2x_tb;

    // Testbench signals (combinational circuit)
    reg ck;
    reg sd;
    reg se;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_u1_scanlg_2x dut (
        .ck(ck),
        .sd(sd),
        .se(se),
        .so(so)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_u1_scanlg_2x Testbench");
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
        input expected_so;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%b",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%b",
                         expected_so);
                $display("  Got:      so=%b",
                         so);
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
