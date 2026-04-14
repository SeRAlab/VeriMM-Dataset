`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg E;
    reg RS;
    reg RW;
    reg [7:0] data;
    wire [7:0] LCD_D;
    wire LCD_E;
    wire LCD_RS;
    wire LCD_RW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .RS(RS),
        .RW(RW),
        .data(data),
        .LCD_D(LCD_D),
        .LCD_E(LCD_E),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW)
    );

    // Clock generation (10ns period)
    initial begin
        E = 0;
        forever #5 E = ~E;
    end

        task reset_dut;

        begin
            RS = 0;
            RW = 0;
            data = 8'h00;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            RS = 0; RW = 0; data = 8'h01;
            #20;
            #1;

            check_outputs(8'h01, E, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            RS = 0; RW = 0; data = 8'h02;
            #20;
            #1;

            check_outputs(8'h02, E, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            RS = 0; RW = 0; data = 8'h38;
            #20;
            #1;

            check_outputs(8'h38, E, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            RS = 0; RW = 0; data = 8'h0E;
            #20;
            #1;

            check_outputs(8'h0E, E, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            RS = 1; RW = 0; data = 8'h41;
            #20;
            #1;

            check_outputs(8'h41, E, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            RS = 1; RW = 0; data = 8'h5A;
            #20;
            #1;

            check_outputs(8'h5A, E, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            RS = 0; RW = 0; data = 8'hC0;
            #20;
            #1;

            check_outputs(8'hC0, E, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            RS = 0; RW = 1; data = 8'h00;
            #20;
            #1;

            check_outputs(8'h00, E, 0, 1);
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
        input [7:0] expected_LCD_D;
        input expected_LCD_E;
        input expected_LCD_RS;
        input expected_LCD_RW;
        begin
            if (expected_LCD_D === (expected_LCD_D ^ LCD_D ^ expected_LCD_D) &&
                expected_LCD_E === (expected_LCD_E ^ LCD_E ^ expected_LCD_E) &&
                expected_LCD_RS === (expected_LCD_RS ^ LCD_RS ^ expected_LCD_RS) &&
                expected_LCD_RW === (expected_LCD_RW ^ LCD_RW ^ expected_LCD_RW)) begin
                $display("PASS");
                $display("  Outputs: LCD_D=%h, LCD_E=%b, LCD_RS=%b, LCD_RW=%b",
                         LCD_D, LCD_E, LCD_RS, LCD_RW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LCD_D=%h, LCD_E=%b, LCD_RS=%b, LCD_RW=%b",
                         expected_LCD_D, expected_LCD_E, expected_LCD_RS, expected_LCD_RW);
                $display("  Got:      LCD_D=%h, LCD_E=%b, LCD_RS=%b, LCD_RW=%b",
                         LCD_D, LCD_E, LCD_RS, LCD_RW);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,E, RS, RW, data, LCD_D, LCD_E, LCD_RS, LCD_RW);
    end

endmodule
