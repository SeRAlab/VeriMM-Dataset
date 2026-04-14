`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] hcount;
    reg reset;
    reg [9:0] vcount;
    reg [35:0] vram_read_data;
    wire [7:0] vr_pixel;
    wire [18:0] vram_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hcount(hcount),
        .reset(reset),
        .vcount(vcount),
        .vram_read_data(vram_read_data),
        .vr_pixel(vr_pixel),
        .vram_addr(vram_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            hcount = 0;
            vcount = 0;
            vram_read_data = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Origin (0,0) Initialization", test_num);
            reset_dut();
            hcount = 11'd0;
            vcount = 10'd0;
            vram_read_data = 36'h0_12345678;

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h78, 19'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Horizontal Increment (2,0)", test_num);
            reset_dut();
            hcount = 11'd2;
            vcount = 10'd0;
            vram_read_data = 36'h0_AABBCCDD;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hDD, 19'h00001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Pixel Selection Mux (1,0)", test_num);
            reset_dut();
            hcount = 11'd1;
            vcount = 10'd0;
            vram_read_data = 36'h0_FFEEFFEE;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 19'h00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Vertical Line Step (0,1)", test_num);
            reset_dut();
            hcount = 11'd0;
            vcount = 10'd1;
            vram_read_data = 36'hF_55AA55AA;
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(8'hAA, 19'd320);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mid-screen Arbitrary Check", test_num);
            reset_dut();
            hcount = 11'd100;
            vcount = 10'd50;
            vram_read_data = 36'hE_0D0C0B0A;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0A, 19'd16050);
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
        input [7:0] expected_vr_pixel;
        input [18:0] expected_vram_addr;
        begin
            if (expected_vr_pixel === (expected_vr_pixel ^ vr_pixel ^ expected_vr_pixel) &&
                expected_vram_addr === (expected_vram_addr ^ vram_addr ^ expected_vram_addr)) begin
                $display("PASS");
                $display("  Outputs: vr_pixel=%h, vram_addr=%h",
                         vr_pixel, vram_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vr_pixel=%h, vram_addr=%h",
                         expected_vr_pixel, expected_vram_addr);
                $display("  Got:      vr_pixel=%h, vram_addr=%h",
                         vr_pixel, vram_addr);
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
        $dumpvars(0,clk, hcount, reset, vcount, vram_read_data, vr_pixel, vram_addr);
    end

endmodule
