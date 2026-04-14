`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] a;
    reg [11:0] b;
    reg [1:0] mode;
    wire [11:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .mode(mode),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 12'h005; b = 12'h00A; mode = 2'b00;
            #10;
            $display("Test %0d: Raw Sum - Simple Addition", test_num);
            #1;

            check_outputs(12'h00F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 12'h7FF; b = 12'h001; mode = 2'b00;
            #10;
            $display("Test %0d: Raw Sum - Wrap Around (Signed Pos to Neg)", test_num);
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 12'h064; b = 12'h0C8; mode = 2'b01;
            #10;
            $display("Test %0d: Signed Sat - Normal Addition", test_num);
            #1;

            check_outputs(12'h12C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 12'h700; b = 12'h200; mode = 2'b01;
            #10;
            $display("Test %0d: Signed Sat - Positive Overflow", test_num);
            #1;

            check_outputs(12'h7FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 12'h900; b = 12'h900; mode = 2'b01;
            #10;
            $display("Test %0d: Signed Sat - Negative Overflow", test_num);
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 12'h7FF; b = 12'h801; mode = 2'b01;
            #10;
            $display("Test %0d: Signed Sat - Cross Zero", test_num);
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 12'hF00; b = 12'h010; mode = 2'b10;
            #10;
            $display("Test %0d: Unsigned Sat - Normal Addition", test_num);
            #1;

            check_outputs(12'hF10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 12'hFFF; b = 12'h002; mode = 2'b10;
            #10;
            $display("Test %0d: Unsigned Sat - Overflow", test_num);
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 12'h800; b = 12'hFFF; mode = 2'b11;
            #10;
            $display("Test %0d: Mode 11 - Raw Sum Fallback", test_num);
            #1;

            check_outputs(12'h7FF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 12'h000; b = 12'h000; mode = 2'b01;
            #10;
            $display("Test %0d: Zero Case", test_num);
            #1;

            check_outputs(12'h000);
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
        input [11:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
