`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] color;
    wire [8:0] char1;
    wire [8:0] char2;
    wire [8:0] char3;
    wire [8:0] char4;
    wire [8:0] char5;
    wire [8:0] char6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .color(color),
        .char1(char1),
        .char2(char2),
        .char3(char3),
        .char4(char4),
        .char5(char5),
        .char6(char6)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Color Input 001", test_num);
            color = 3'b001;

            #1;


            check_outputs(9'h052, 9'h045, 9'h044, 9'h020, 9'h020, 9'h020);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Color Input 010", test_num);
            color = 3'b010;

            #1;


            check_outputs(9'h047, 9'h052, 9'h045, 9'h045, 9'h04e, 9'h020);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Color Input 100", test_num);
            color = 3'b100;

            #1;


            check_outputs(9'h042, 9'h04c, 9'h055, 9'h045, 9'h020, 9'h020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Color Input 000 (Default Case)", test_num);
            color = 3'b000;

            #1;


            check_outputs(9'h000, 9'h000, 9'h000, 9'h000, 9'h000, 9'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Color Input 111 (Default Case)", test_num);
            color = 3'b111;

            #1;


            check_outputs(9'h000, 9'h000, 9'h000, 9'h000, 9'h000, 9'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Color Input 011 (Default Case)", test_num);
            color = 3'b011;
            #1;

            check_outputs(9'h000, 9'h000, 9'h000, 9'h000, 9'h000, 9'h000);
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
        input [8:0] expected_char1;
        input [8:0] expected_char2;
        input [8:0] expected_char3;
        input [8:0] expected_char4;
        input [8:0] expected_char5;
        input [8:0] expected_char6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_char1 === (expected_char1 ^ char1 ^ expected_char1) &&
                expected_char2 === (expected_char2 ^ char2 ^ expected_char2) &&
                expected_char3 === (expected_char3 ^ char3 ^ expected_char3) &&
                expected_char4 === (expected_char4 ^ char4 ^ expected_char4) &&
                expected_char5 === (expected_char5 ^ char5 ^ expected_char5) &&
                expected_char6 === (expected_char6 ^ char6 ^ expected_char6)) begin
                $display("PASS");
                $display("  Outputs: char1=%h, char2=%h, char3=%h, char4=%h, char5=%h, char6=%h",
                         char1, char2, char3, char4, char5, char6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: char1=%h, char2=%h, char3=%h, char4=%h, char5=%h, char6=%h",
                         expected_char1, expected_char2, expected_char3, expected_char4, expected_char5, expected_char6);
                $display("  Got:      char1=%h, char2=%h, char3=%h, char4=%h, char5=%h, char6=%h",
                         char1, char2, char3, char4, char5, char6);
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
