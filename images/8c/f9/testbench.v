`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    wire [18:0] mem_add;
    wire vga_blank;
    wire vga_clock;
    wire vga_hsync;
    wire vga_sync;
    wire vga_vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .mem_add(mem_add),
        .vga_blank(vga_blank),
        .vga_clock(vga_clock),
        .vga_hsync(vga_hsync),
        .vga_sync(vga_sync),
        .vga_vsync(vga_vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin



            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking Start of Frame (0,0)", test_num);
            reset_dut();
            @(posedge clock); #1;

            #1;


            check_outputs(19'h00000, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking Middle of Line 0 (100,0)", test_num);

            repeat(100) @(posedge clock); #1;
            #1;

            check_outputs(19'd100, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking H-Blanking start (640,0)", test_num);

            repeat(540) @(posedge clock); #1;

            #1;


            check_outputs(19'd640, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking H-Sync pulse start (656,0)", test_num);

            repeat(16) @(posedge clock); #1;

            #1;


            check_outputs(19'd640, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking Start of Line 1 (0,1)", test_num);

            repeat(144) @(posedge clock); #1;

            #1;


            check_outputs(19'd640, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking Start of Line 10 (0,10)", test_num);

            repeat(7200) @(posedge clock); #1;

            #1;


            check_outputs(19'd6400, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Checking Blanking of Line 10 (640,10)", test_num);
            repeat(640) @(posedge clock); #1;

            #1;


            check_outputs(19'd7040, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
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
        input [18:0] expected_mem_add;
        input expected_vga_blank;
        input expected_vga_clock;
        input expected_vga_hsync;
        input expected_vga_sync;
        input expected_vga_vsync;
        begin
            if (expected_mem_add === (expected_mem_add ^ mem_add ^ expected_mem_add) &&
                expected_vga_blank === (expected_vga_blank ^ vga_blank ^ expected_vga_blank) &&
                expected_vga_clock === (expected_vga_clock ^ vga_clock ^ expected_vga_clock) &&
                expected_vga_hsync === (expected_vga_hsync ^ vga_hsync ^ expected_vga_hsync) &&
                expected_vga_sync === (expected_vga_sync ^ vga_sync ^ expected_vga_sync) &&
                expected_vga_vsync === (expected_vga_vsync ^ vga_vsync ^ expected_vga_vsync)) begin
                $display("PASS");
                $display("  Outputs: mem_add=%h, vga_blank=%b, vga_clock=%b, vga_hsync=%b, vga_sync=%b, vga_vsync=%b",
                         mem_add, vga_blank, vga_clock, vga_hsync, vga_sync, vga_vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_add=%h, vga_blank=%b, vga_clock=%b, vga_hsync=%b, vga_sync=%b, vga_vsync=%b",
                         expected_mem_add, expected_vga_blank, expected_vga_clock, expected_vga_hsync, expected_vga_sync, expected_vga_vsync);
                $display("  Got:      mem_add=%h, vga_blank=%b, vga_clock=%b, vga_hsync=%b, vga_sync=%b, vga_vsync=%b",
                         mem_add, vga_blank, vga_clock, vga_hsync, vga_sync, vga_vsync);
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
        $dumpvars(0,clock, mem_add, vga_blank, vga_clock, vga_hsync, vga_sync, vga_vsync);
    end

endmodule
