`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            a = 8'd15;
            b = 8'd20;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase003;

        begin
            a = 8'd128;
            b = 8'd127;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            a = 8'hFF;
            b = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            a = 8'hF0;
            b = 8'hF0;
            #1;

            check_outputs(8'hE0);
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
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%b",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%b",
                         expected_sum);
                $display("  Got:      sum=%b",
                         sum);
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
