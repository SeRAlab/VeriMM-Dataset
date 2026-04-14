`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A1;
    reg [1:0] A2;
    reg [1:0] A3;
    reg [1:0] A4;
    reg [1:0] A5;
    reg [1:0] A6;
    wire Y1;
    wire Y2;
    wire Y3;
    wire Y4;
    wire Y5;
    wire Y6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .A5(A5),
        .A6(A6),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3),
        .Y4(Y4),
        .Y5(Y5),
        .Y6(Y6)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All inputs 2'b00");
            A1 = 2'b00; A2 = 2'b00; A3 = 2'b00; A4 = 2'b00; A5 = 2'b00; A6 = 2'b00;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All inputs 2'b11");
            A1 = 2'b11; A2 = 2'b11; A3 = 2'b11; A4 = 2'b11; A5 = 2'b11; A6 = 2'b11;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: All inputs 2'b10");
            A1 = 2'b10; A2 = 2'b10; A3 = 2'b10; A4 = 2'b10; A5 = 2'b10; A6 = 2'b10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: All inputs 2'b01");
            A1 = 2'b01; A2 = 2'b01; A3 = 2'b01; A4 = 2'b01; A5 = 2'b01; A6 = 2'b01;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Mixed Inputs");

            A1 = 2'b10;

            A2 = 2'b11;

            A3 = 2'b01;

            A4 = 2'b00;

            A5 = 2'b01;

            A6 = 2'b11;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Inverse Mixed Inputs");
            A1 = 2'b11;
            A2 = 2'b01;
            A3 = 2'b00;
            A4 = 2'b10;
            A5 = 2'b11;
            A6 = 2'b10;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_Y1;
        input expected_Y2;
        input expected_Y3;
        input expected_Y4;
        input expected_Y5;
        input expected_Y6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3) &&
                expected_Y4 === (expected_Y4 ^ Y4 ^ expected_Y4) &&
                expected_Y5 === (expected_Y5 ^ Y5 ^ expected_Y5) &&
                expected_Y6 === (expected_Y6 ^ Y6 ^ expected_Y6)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y2=%b, Y3=%b, Y4=%b, Y5=%b, Y6=%b",
                         Y1, Y2, Y3, Y4, Y5, Y6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y2=%b, Y3=%b, Y4=%b, Y5=%b, Y6=%b",
                         expected_Y1, expected_Y2, expected_Y3, expected_Y4, expected_Y5, expected_Y6);
                $display("  Got:      Y1=%b, Y2=%b, Y3=%b, Y4=%b, Y5=%b, Y6=%b",
                         Y1, Y2, Y3, Y4, Y5, Y6);
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
