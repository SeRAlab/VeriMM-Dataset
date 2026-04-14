`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input_matrix;
    reg [8:0] kernel;
    wire [3:0] output_conv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_matrix(input_matrix),
        .kernel(kernel),
        .output_conv(output_conv)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            input_matrix = 16'h0000;
            kernel = 9'h000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            input_matrix = 16'hFFFF;
            kernel = 9'h1FF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center Kernel Hit", test_num);
            input_matrix = 16'b0000_0100_0000_0000;
            kernel       = 9'b000_010_000;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Top-Left Edge", test_num);
            input_matrix = 16'h8000;
            kernel       = 9'h100;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bottom-Right Edge", test_num);
            input_matrix = 16'h0001;
            kernel       = 9'h001;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Mismatch", test_num);
            input_matrix = 16'hAAAA;
            kernel       = 9'h000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Line Detection", test_num);
            input_matrix = 16'hF000;
            kernel       = 9'h1C0;

            #1;


            check_outputs(4'h3);
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
        input [3:0] expected_output_conv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_conv === (expected_output_conv ^ output_conv ^ expected_output_conv)) begin
                $display("PASS");
                $display("  Outputs: output_conv=%h",
                         output_conv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_conv=%h",
                         expected_output_conv);
                $display("  Got:      output_conv=%h",
                         output_conv);
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
