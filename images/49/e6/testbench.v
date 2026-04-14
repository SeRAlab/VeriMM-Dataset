`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg hsync;
    reg pixel_clk_2x;
    reg [23:0] pixel_data;
    wire [11:0] vga_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hsync(hsync),
        .pixel_clk_2x(pixel_clk_2x),
        .pixel_data(pixel_data),
        .vga_out(vga_out)
    );

    // Clock generation (10ns period)
    initial begin
        pixel_clk_2x = 0;
        forever #5 pixel_clk_2x = ~pixel_clk_2x;
    end

        task reset_dut;

        begin
            hsync = 0;
            pixel_data = 24'h0;
            @(negedge pixel_clk_2x);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            pixel_data = 24'hABCDEF;
            hsync = 1;
            @(posedge pixel_clk_2x);
            #1;
            #1;

            check_outputs(12'hDEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            pixel_data = 24'hABCDEF;
            hsync = 1;
            @(posedge pixel_clk_2x);
            @(posedge pixel_clk_2x);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            pixel_data = 24'h123456;
            hsync = 1;
            repeat(3) @(posedge pixel_clk_2x);
            #1;
            #1;

            check_outputs(12'h456);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            pixel_data = 24'h123456;
            hsync = 1;
            repeat(4) @(posedge pixel_clk_2x);
            #1;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            pixel_data = 24'hAAAAAA;
            hsync = 1;
            @(posedge pixel_clk_2x);
            @(posedge pixel_clk_2x);

            hsync = 0;
            @(posedge pixel_clk_2x);
            #1;
            #1;

            check_outputs(12'hAAA);
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
        input [11:0] expected_vga_out;
        begin
            if (expected_vga_out === (expected_vga_out ^ vga_out ^ expected_vga_out)) begin
                $display("PASS");
                $display("  Outputs: vga_out=%h",
                         vga_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vga_out=%h",
                         expected_vga_out);
                $display("  Got:      vga_out=%h",
                         vga_out);
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
        $dumpvars(0,hsync, pixel_clk_2x, pixel_data, vga_out);
    end

endmodule
