`timescale 1ns/1ps

module sr_latch_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sr_latch dut (
        .r(r),
        .s(s),
        .q(q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset logic (s=0, r=1)");

            s = 0; r = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Set logic (s=1, r=0)");

            s = 0; r = 1;
            #10;

            s = 1; r = 0;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Hold State after Set (s=0, r=0)");

            s = 0; r = 1;
            #10;

            s = 1; r = 0;
            #10;

            s = 0; r = 0;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Reset after Set (s=0, r=1)");

            s = 0; r = 1;
            #10;

            s = 1; r = 0;
            #10;

            s = 0; r = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Hold State after Reset (s=0, r=0)");

            s = 0; r = 1;
            #10;

            s = 0; r = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sr_latch Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
