`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [3:0] abs_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .abs_val(abs_val)
    );
    task testcase001;

        begin
            test_num = 1;
            binary = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary = 4'b0011;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary = 4'b0111;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary = 4'b1111;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary = 4'b1100;

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary = 4'b1010;

            #1;


            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary = 4'b1001;

            #1;


            check_outputs(4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary = 4'b1000;

            #1;


            check_outputs(4'b1000);
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
        input [3:0] expected_abs_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_abs_val === (expected_abs_val ^ abs_val ^ expected_abs_val)) begin
                $display("PASS");
                $display("  Outputs: abs_val=%h",
                         abs_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abs_val=%h",
                         expected_abs_val);
                $display("  Got:      abs_val=%h",
                         abs_val);
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
