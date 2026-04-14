`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg WVAL;
    wire WGET;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WVAL(WVAL),
        .WGET(WGET)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving input to logic 0", test_num);
            WVAL = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving input to logic 1", test_num);
            WVAL = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle test 0 -> 1 -> 0", test_num);
            WVAL = 1'b0;
            #10;
            WVAL = 1'b1;
            #10;
            WVAL = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle test 1 -> 0 -> 1", test_num);
            WVAL = 1'b1;
            #10;
            WVAL = 1'b0;
            #10;
            WVAL = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High impedance/undefined propagation check (X)", test_num);
            WVAL = 1'bx;
            #1;

            check_outputs(1'bx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_WGET;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WGET === (expected_WGET ^ WGET ^ expected_WGET)) begin
                $display("PASS");
                $display("  Outputs: WGET=%b",
                         WGET);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WGET=%b",
                         expected_WGET);
                $display("  Got:      WGET=%b",
                         WGET);
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
