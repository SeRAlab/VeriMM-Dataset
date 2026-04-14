`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] diff;
    wire [7:0] prod;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .diff(diff),
        .prod(prod),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'd10;
            b = 8'd5;
            #1;

            check_outputs(8'd5, 8'd50, 8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'd5;
            b = 8'd10;

            #1;


            check_outputs(8'd251, 8'd50, 8'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'd200;
            b = 8'd100;



            #1;




            check_outputs(8'd100, 8'd32, 8'd44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'hFF;



            #1;




            check_outputs(8'd0, 8'd1, 8'd254);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'd128;
            b = 8'd2;



            #1;




            check_outputs(8'd126, 8'd0, 8'd130);
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
        input [7:0] expected_diff;
        input [7:0] expected_prod;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff) &&
                expected_prod === (expected_prod ^ prod ^ expected_prod) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: diff=%h, prod=%h, sum=%h",
                         diff, prod, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h, prod=%h, sum=%h",
                         expected_diff, expected_prod, expected_sum);
                $display("  Got:      diff=%h, prod=%h, sum=%h",
                         diff, prod, sum);
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
