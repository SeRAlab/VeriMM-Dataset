`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] value;
    wire [15:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .value(value),
        .display(display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        value = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task run_test;

        input [6:0] test_val;
        input [15:0] expected_hex;
        begin
            test_num = test_num + 1;
            value = test_val;
            @(posedge clk);
            #2;
            $display("Test Case %03d: Input Value = %d", test_num, test_val);
            #1;

            check_outputs(expected_hex);
        end
        endtask

    task testcase001;

    begin
        reset_dut();
        run_test(7'd0, 16'h003f);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        run_test(7'd1, 16'h0006);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        run_test(7'd2, 16'h005b);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        run_test(7'd3, 16'h004f);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        run_test(7'd4, 16'h0066);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        run_test(7'd5, 16'h006d);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        run_test(7'd6, 16'h007d);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        run_test(7'd7, 16'h0007);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        run_test(7'd8, 16'h007f);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        run_test(7'd9, 16'h006f);
    end
        endtask

    task testcase011;

    begin
        reset_dut();
        run_test(7'd10, 16'h0077);
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
        testcase011();
        
        
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
        input [15:0] expected_display;
        begin
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
        $dumpvars(0,clk, value, display);
    end

endmodule
