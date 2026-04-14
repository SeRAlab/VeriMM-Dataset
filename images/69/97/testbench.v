`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg [3:0] in;
    reg rst_n;
    reg [1:0] sel;
    wire down;
    wire out;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .in(in),
        .rst_n(rst_n),
        .sel(sel),
        .down(down),
        .out(out),
        .rise(rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            in = 4'b0000;
            sel = 2'b00;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 1;
            @(posedge clk);
            a = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 4'b1011;
            sel = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 4'b1101;
            sel = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 4'b1101;
            sel = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in = 4'b0111;
            sel = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            a = 1; @(posedge clk);
            a = 0; @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            in = 4'b1000;
            sel = 2'b11;
            a = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 1);
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
        input expected_down;
        input expected_out;
        input expected_rise;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: down=%b, out=%b, rise=%b",
                         down, out, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, out=%b, rise=%b",
                         expected_down, expected_out, expected_rise);
                $display("  Got:      down=%b, out=%b, rise=%b",
                         down, out, rise);
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
        $dumpvars(0,a, clk, in, rst_n, sel, down, out, rise);
    end

endmodule
