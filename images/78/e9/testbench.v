`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg rst_n;
    wire down;
    wire [7:0] final_out;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst_n(rst_n),
        .down(down),
        .final_out(final_out),
        .out_hi(out_hi),
        .out_lo(out_lo),
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
            in = 16'h0000;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(0, 8'h00, 8'h00, 8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in = 16'hA501;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 8'hA5, 8'hA5, 8'h01, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 16'h0001;
            @(posedge clk);
            #1;
            in = 16'h5A00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 8'h5B, 8'h5A, 8'h00, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 16'h0001;
            @(posedge clk);
            #1;
            in = 16'h1201;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 8'h13, 8'h12, 8'h01, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 16'h0000;
            @(posedge clk);
            #1;
            in = 16'h8800;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 8'h88, 8'h88, 8'h00, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 16'h0000;
            @(posedge clk);
            #1;
            in = 16'h1020;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 8'h30, 8'h10, 8'h20, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in = 16'h0000;
            @(posedge clk);
            #1;
            in = 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 8'hFF, 8'hFF, 8'hFF, 1);
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
        input [7:0] expected_final_out;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input expected_rise;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: down=%b, final_out=%h, out_hi=%h, out_lo=%h, rise=%b",
                         down, final_out, out_hi, out_lo, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, final_out=%h, out_hi=%h, out_lo=%h, rise=%b",
                         expected_down, expected_final_out, expected_out_hi, expected_out_lo, expected_rise);
                $display("  Got:      down=%b, final_out=%h, out_hi=%h, out_lo=%h, rise=%b",
                         down, final_out, out_hi, out_lo, rise);
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
        $dumpvars(0,clk, in, rst_n, down, final_out, out_hi, out_lo, rise);
    end

endmodule
