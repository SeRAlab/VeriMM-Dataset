`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg b1;
    reg b2;
    reg b3;
    wire b_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .b_out(b_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=0, b2=0, b3=0", test_num);
            b1 = 0; b2 = 0; b3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=0, b2=0, b3=1", test_num);
            b1 = 0; b2 = 0; b3 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=0, b2=1, b3=0", test_num);
            b1 = 0; b2 = 1; b3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=0, b2=1, b3=1", test_num);
            b1 = 0; b2 = 1; b3 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=1, b2=0, b3=0", test_num);
            b1 = 1; b2 = 0; b3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=1, b2=0, b3=1", test_num);
            b1 = 1; b2 = 0; b3 = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=1, b2=1, b3=0", test_num);
            b1 = 1; b2 = 1; b3 = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: b1=1, b2=1, b3=1", test_num);
            b1 = 1; b2 = 1; b3 = 1;
            #1;

            check_outputs(1);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_b_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out)) begin
                $display("PASS");
                $display("  Outputs: b_out=%b",
                         b_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%b",
                         expected_b_out);
                $display("  Got:      b_out=%b",
                         b_out);
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
