`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Simple Division (20 / 4)", test_num);
        A = 8'd20;
        B = 8'd4;
        #10;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Maximum Dividend by 1 (255 / 1)", test_num);
        A = 8'd255;
        B = 8'd1;
        #10;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Division with Remainder (100 / 7)", test_num);
        A = 8'd100;
        B = 8'd7;
        #10;
        #1;

        check_outputs(8'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Dividend is Zero (0 / 50)", test_num);
        A = 8'd0;
        B = 8'd50;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Dividend Less Than Divisor (5 / 10)", test_num);
        A = 8'd5;
        B = 8'd10;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Division by Same Value (255 / 255)", test_num);
        A = 8'd255;
        B = 8'd255;
        #10;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Large Result (200 / 2)", test_num);
        A = 8'd200;
        B = 8'd2;
        #10;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Division of High Bits (128 / 4)", test_num);
        A = 8'h80;
        B = 8'h04;
        #10;
        #1;

        check_outputs(8'd32);
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
