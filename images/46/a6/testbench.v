`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    wire [31:0] exp_x;
    wire [31:0] ln_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .exp_x(exp_x),
        .ln_x(ln_x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input x = 0 (Boundary Case)", test_num);
            x = 16'sd0;

            #1;


            check_outputs(32'h00000001, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input x = -1 (Negative Case)", test_num);
            x = -16'sd1;

            #1;


            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input x = -32768 (Minimum Signed Value)", test_num);
            x = 16'h8000;

            #1;


            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input x = 1 (Positive Taylor Path)", test_num);
            x = 16'sd1;





            #1;
            if (ln_x === 32'h0) begin
                $display("PASS: ln(1) is 0");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected ln(1)=0, Got %h", ln_x);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input x = 10 (Positive Logic Check)", test_num);
            x = 16'sd10;
            #1;


            if (ln_x !== 32'hFFFFFFFF && exp_x !== 32'h0) begin
                $display("PASS: Logic branch for positive x verified (Non-error outputs)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Positive input returned negative-case error values");
                fail_count = fail_count + 1;
            end
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
        input [31:0] expected_exp_x;
        input [31:0] expected_ln_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exp_x === (expected_exp_x ^ exp_x ^ expected_exp_x) &&
                expected_ln_x === (expected_ln_x ^ ln_x ^ expected_ln_x)) begin
                $display("PASS");
                $display("  Outputs: exp_x=%h, ln_x=%h",
                         exp_x, ln_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exp_x=%h, ln_x=%h",
                         expected_exp_x, expected_ln_x);
                $display("  Got:      exp_x=%h, ln_x=%h",
                         exp_x, ln_x);
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
