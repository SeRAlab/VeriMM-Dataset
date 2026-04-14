`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] OP;
    wire FLAG;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .FLAG(FLAG),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition (10 + 20)", test_num);
        A = 8'sd10;
        B = 8'sd20;
        OP = 2'b00;
        #1;

        check_outputs(1'b0, 8'sd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive Addition Overflow (120 + 10)", test_num);
        A = 8'sd120;
        B = 8'sd10;
        OP = 2'b00;

        #1;


        check_outputs(1'b1, 8'sh82);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Addition Overflow (-120 + -10)", test_num);
        A = -8'sd120;
        B = -8'sd10;
        OP = 2'b00;

        #1;


        check_outputs(1'b1, 8'sh7E);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Subtraction (50 - 20)", test_num);
        A = 8'sd50;
        B = 8'sd20;
        OP = 2'b01;
        #1;

        check_outputs(1'b0, 8'sd30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Overflow (100 - -40)", test_num);
        A = 8'sd100;
        B = -8'sd40;
        OP = 2'b01;

        #1;


        check_outputs(1'b1, 8'sh8C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Multiplication (12 * 4)", test_num);
        A = 8'sd12;
        B = 8'sd4;
        OP = 2'b10;
        #1;

        check_outputs(1'b0, 8'sd48);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication Overflow (20 * 10)", test_num);
        A = 8'sd20;
        B = 8'sd10;
        OP = 2'b10;

        #1;


        check_outputs(1'b1, 8'shC8);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Division (100 / 5)", test_num);
        A = 8'sd100;
        B = 8'sd5;
        OP = 2'b11;
        #1;

        check_outputs(1'b0, 8'sd20);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division by Zero", test_num);
        A = 8'sd50;
        B = 8'sd0;
        OP = 2'b11;
        #1;

        check_outputs(1'b1, Y);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division Overflow (-128 / -1)", test_num);
        A = -8'sd128;
        B = -8'sd1;
        OP = 2'b11;

        #1;


        check_outputs(1'b1, 8'sh80);
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
        input expected_FLAG;
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FLAG === (expected_FLAG ^ FLAG ^ expected_FLAG) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: FLAG=%b, Y=%h",
                         FLAG, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FLAG=%b, Y=%h",
                         expected_FLAG, expected_Y);
                $display("  Got:      FLAG=%b, Y=%h",
                         FLAG, Y);
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
