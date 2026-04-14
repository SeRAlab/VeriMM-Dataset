`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num;
    wire [7:0] abs_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .abs_num(abs_num)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            num = 8'sd0;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            num = 8'sd1;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            num = -8'sd1;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            num = 8'sd127;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            num = -8'sd128;
            $display("Testcase %03d: Input %d", test_num, num);

            #1;


            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            num = 8'sd42;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            num = -8'sd42;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            num = -8'sd127;
            $display("Testcase %03d: Input %d", test_num, num);
            #1;

            check_outputs(8'd127);
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
        input [7:0] expected_abs_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_abs_num === (expected_abs_num ^ abs_num ^ expected_abs_num)) begin
                $display("PASS");
                $display("  Outputs: abs_num=%h",
                         abs_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abs_num=%h",
                         expected_abs_num);
                $display("  Got:      abs_num=%h",
                         abs_num);
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
