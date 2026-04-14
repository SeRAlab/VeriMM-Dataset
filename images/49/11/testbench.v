`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data;
    wire pad;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .pad(pad)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving Low (0)", test_num);
            data = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Driving High (1)", test_num);
            data = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from High to Low", test_num);
            data = 1'b1;
            #10;
            data = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition from Low to High", test_num);
            data = 1'b0;
            #10;
            data = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying stability after multiple changes", test_num);
            data = 1'b1; #5;
            data = 1'b0; #5;
            data = 1'b1; #5;
            data = 1'b0;
            #1;

            check_outputs(1'b0);
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
        input expected_pad;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pad === (expected_pad ^ pad ^ expected_pad)) begin
                $display("PASS");
                $display("  Outputs: pad=%b",
                         pad);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pad=%b",
                         expected_pad);
                $display("  Got:      pad=%b",
                         pad);
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
