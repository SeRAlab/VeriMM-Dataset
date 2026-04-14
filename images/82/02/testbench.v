`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] number;
    wire [3:0] lowerDigit;
    wire [3:0] upperDigit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .number(number),
        .lowerDigit(lowerDigit),
        .upperDigit(upperDigit)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input number = 0", test_num);
            number = 8'd0;


            #1;



            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input number = 9", test_num);
            number = 8'd9;


            #1;



            check_outputs(4'd9, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input number = 10", test_num);
            number = 8'd10;


            #1;



            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input number = 47", test_num);
            number = 8'd47;


            #1;



            check_outputs(4'd7, 4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input number = 99", test_num);
            number = 8'd99;


            #1;



            check_outputs(4'd9, 4'd9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input number = 100", test_num);
            number = 8'd100;


            #1;



            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input number = 158", test_num);
            number = 8'd158;


            #1;



            check_outputs(4'd8, 4'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input number = 255 (Max 8-bit)", test_num);
            number = 8'd255;


            #1;



            check_outputs(4'd5, 4'd5);
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
        input [3:0] expected_lowerDigit;
        input [3:0] expected_upperDigit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lowerDigit === (expected_lowerDigit ^ lowerDigit ^ expected_lowerDigit) &&
                expected_upperDigit === (expected_upperDigit ^ upperDigit ^ expected_upperDigit)) begin
                $display("PASS");
                $display("  Outputs: lowerDigit=%h, upperDigit=%h",
                         lowerDigit, upperDigit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lowerDigit=%h, upperDigit=%h",
                         expected_lowerDigit, expected_upperDigit);
                $display("  Got:      lowerDigit=%h, upperDigit=%h",
                         lowerDigit, upperDigit);
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
