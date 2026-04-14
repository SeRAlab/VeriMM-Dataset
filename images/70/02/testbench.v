`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [10:0] CounterX;
    wire [10:0] CounterY;
    wire inDisplayArea;
    wire vga_h_sync;
    wire vga_v_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .CounterX(CounterX),
        .CounterY(CounterY),
        .inDisplayArea(inDisplayArea),
        .vga_h_sync(vga_h_sync),
        .vga_v_sync(vga_v_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(11'd0, 11'd0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat (639) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd639, 11'd0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat (640) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd640, 11'd0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat (656) @(posedge clk);
            #1;

            #1;


            check_outputs(11'd656, 11'd0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat (800) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd0, 11'd1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat (800 * 480) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd0, 11'd480, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat (800 * 490) @(posedge clk);
            #1;

            #1;


            check_outputs(11'd0, 11'd490, 1'b0, 1'b1, 1'b0);
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
        input [10:0] expected_CounterX;
        input [10:0] expected_CounterY;
        input expected_inDisplayArea;
        input expected_vga_h_sync;
        input expected_vga_v_sync;
        begin
            if (expected_CounterX === (expected_CounterX ^ CounterX ^ expected_CounterX) &&
                expected_CounterY === (expected_CounterY ^ CounterY ^ expected_CounterY) &&
                expected_inDisplayArea === (expected_inDisplayArea ^ inDisplayArea ^ expected_inDisplayArea) &&
                expected_vga_h_sync === (expected_vga_h_sync ^ vga_h_sync ^ expected_vga_h_sync) &&
                expected_vga_v_sync === (expected_vga_v_sync ^ vga_v_sync ^ expected_vga_v_sync)) begin
                $display("PASS");
                $display("  Outputs: CounterX=%h, CounterY=%h, inDisplayArea=%b, vga_h_sync=%b, vga_v_sync=%b",
                         CounterX, CounterY, inDisplayArea, vga_h_sync, vga_v_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CounterX=%h, CounterY=%h, inDisplayArea=%b, vga_h_sync=%b, vga_v_sync=%b",
                         expected_CounterX, expected_CounterY, expected_inDisplayArea, expected_vga_h_sync, expected_vga_v_sync);
                $display("  Got:      CounterX=%h, CounterY=%h, inDisplayArea=%b, vga_h_sync=%b, vga_v_sync=%b",
                         CounterX, CounterY, inDisplayArea, vga_h_sync, vga_v_sync);
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
        $dumpvars(0,clk, reset, CounterX, CounterY, inDisplayArea, vga_h_sync, vga_v_sync);
    end

endmodule
