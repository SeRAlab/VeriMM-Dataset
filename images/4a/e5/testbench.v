`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk25mhz;
    wire [9:0] hindex;
    wire hsync;
    wire [9:0] vindex;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk25mhz(clk25mhz),
        .hindex(hindex),
        .hsync(hsync),
        .vindex(vindex),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk25mhz = 0;
        forever #5 clk25mhz = ~clk25mhz;
    end

        task reset_dut;

        begin
            @(posedge clk25mhz);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking hindex increment...", test_num);
            reset_dut();
            repeat (9) @(posedge clk25mhz);
            #1;

            #1;


            check_outputs(10'd10, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking horizontal rollover (800 pixels)...", test_num);
            reset_dut();
            repeat (789) @(posedge clk25mhz);
            #1;

            #1;


            check_outputs(10'd0, 1'b1, 10'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking HSync pulse activation...", test_num);
            reset_dut();
            repeat (655) @(posedge clk25mhz);
            #1;

            #1;


            check_outputs(10'd656, 1'b0, 10'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking HSync pulse deactivation...", test_num);
            reset_dut();
            repeat (95) @(posedge clk25mhz);
            #1;

            #1;


            check_outputs(10'd752, 1'b1, 10'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking vertical index at 100 lines...", test_num);
            reset_dut();


            repeat (78447) @(posedge clk25mhz);
            #1;

            #1;


            check_outputs(10'd0, 1'b1, 10'd100, 1'b1);
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
        input [9:0] expected_hindex;
        input expected_hsync;
        input [9:0] expected_vindex;
        input expected_vsync;
        begin
            if (expected_hindex === (expected_hindex ^ hindex ^ expected_hindex) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vindex === (expected_vindex ^ vindex ^ expected_vindex) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: hindex=%h, hsync=%b, vindex=%h, vsync=%b",
                         hindex, hsync, vindex, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hindex=%h, hsync=%b, vindex=%h, vsync=%b",
                         expected_hindex, expected_hsync, expected_vindex, expected_vsync);
                $display("  Got:      hindex=%h, hsync=%b, vindex=%h, vsync=%b",
                         hindex, hsync, vindex, vsync);
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
        $dumpvars(0,clk25mhz, hindex, hsync, vindex, vsync);
    end

endmodule
