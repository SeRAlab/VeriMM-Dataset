`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] input_matrix;
    reg [8:0] kernel_matrix;
    wire [24:0] output_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_matrix(input_matrix),
        .kernel_matrix(kernel_matrix),
        .output_matrix(output_matrix)
    );
    task testcase001;

        begin
            test_num = 1;
            input_matrix = 25'h0;
            kernel_matrix = 9'h0;
            #1;

            check_outputs(25'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input_matrix = 25'h1FFFFFF;
            kernel_matrix = 9'h000;
            #1;

            check_outputs(25'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input_matrix = 25'h1555555;
            kernel_matrix = 9'h010;
            #1;

            check_outputs(25'h0051140);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input_matrix = 25'h1FFFFFF;
            kernel_matrix = 9'h1FF;
            #1;

            check_outputs(25'h00739C0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input_matrix = 25'h0001000;
            kernel_matrix = 9'h1FF;
            #1;

            check_outputs(25'h00739C0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input_matrix = 25'h0001000;
            kernel_matrix = 9'h001;
            #1;

            check_outputs(25'h0040000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input_matrix = 25'h0001000;
            kernel_matrix = 9'h100;
            #1;

            check_outputs(25'h0000040);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            input_matrix = 25'h0000001;
            kernel_matrix = 9'h001;
            #1;

            check_outputs(25'h0000040);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            input_matrix = 25'h0040040;
            kernel_matrix = 9'h101;
            #1;

            check_outputs(25'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            input_matrix = 25'h0000020;
            kernel_matrix = 9'h010;
            #1;

            check_outputs(25'h0);
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
        testcase009();
        testcase010();
        
        
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
        input [24:0] expected_output_matrix;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_matrix === (expected_output_matrix ^ output_matrix ^ expected_output_matrix)) begin
                $display("PASS");
                $display("  Outputs: output_matrix=%h",
                         output_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_matrix=%h",
                         expected_output_matrix);
                $display("  Got:      output_matrix=%h",
                         output_matrix);
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
