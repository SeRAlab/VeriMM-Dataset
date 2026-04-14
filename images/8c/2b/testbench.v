`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c1;
    reg c2;
    wire c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c1(c1),
        .c2(c2),
        .c_out(c_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: c1=0, c2=0", test_num);
            c1 = 1'b0;
            c2 = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: c1=0, c2=1", test_num);
            c1 = 1'b0;
            c2 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: c1=1, c2=0", test_num);
            c1 = 1'b1;
            c2 = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: c1=1, c2=1", test_num);
            c1 = 1'b1;
            c2 = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: c_out=%b",
                         c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%b",
                         expected_c_out);
                $display("  Got:      c_out=%b",
                         c_out);
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
