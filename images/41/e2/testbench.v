`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_pix;
    reg rst_n;
    wire vga_b;
    wire vga_g;
    wire vga_hs;
    wire vga_r;
    wire vga_vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_pix(clk_pix),
        .rst_n(rst_n),
        .vga_b(vga_b),
        .vga_g(vga_g),
        .vga_hs(vga_hs),
        .vga_r(vga_r),
        .vga_vs(vga_vs)
    );

    // Clock generation (10ns period)
    initial begin
        clk_pix = 0;
        forever #5 clk_pix = ~clk_pix;
    end

        task reset_dut;

        begin
            rst_n = 0;
            #20;
            rst_n = 1;
            @(posedge clk_pix);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Post-Reset Initialization", test_num);
            reset_dut();


            #1;



            check_outputs(vga_b, vga_g, 1'b1, vga_r, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Active Video Region (Line 0, Pixel 100)", test_num);
            reset_dut();
            repeat(100) @(posedge clk_pix);
            #1;

            #1;


            check_outputs(vga_b, vga_g, 1'b1, vga_r, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Horizontal Sync Pulse", test_num);
            reset_dut();

            repeat(700) @(posedge clk_pix);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start of Second Line", test_num);
            reset_dut();

            repeat(810) @(posedge clk_pix);
            #1;


            #1;



            check_outputs(vga_b, vga_g, 1'b1, vga_r, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Sync Pulse", test_num);
            reset_dut();


            repeat(395000) @(posedge clk_pix);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, vga_hs, 1'b0, 1'b0);
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
        input expected_vga_b;
        input expected_vga_g;
        input expected_vga_hs;
        input expected_vga_r;
        input expected_vga_vs;
        begin
            if (expected_vga_b === (expected_vga_b ^ vga_b ^ expected_vga_b) &&
                expected_vga_g === (expected_vga_g ^ vga_g ^ expected_vga_g) &&
                expected_vga_hs === (expected_vga_hs ^ vga_hs ^ expected_vga_hs) &&
                expected_vga_r === (expected_vga_r ^ vga_r ^ expected_vga_r) &&
                expected_vga_vs === (expected_vga_vs ^ vga_vs ^ expected_vga_vs)) begin
                $display("PASS");
                $display("  Outputs: vga_b=%b, vga_g=%b, vga_hs=%b, vga_r=%b, vga_vs=%b",
                         vga_b, vga_g, vga_hs, vga_r, vga_vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vga_b=%b, vga_g=%b, vga_hs=%b, vga_r=%b, vga_vs=%b",
                         expected_vga_b, expected_vga_g, expected_vga_hs, expected_vga_r, expected_vga_vs);
                $display("  Got:      vga_b=%b, vga_g=%b, vga_hs=%b, vga_r=%b, vga_vs=%b",
                         vga_b, vga_g, vga_hs, vga_r, vga_vs);
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
        $dumpvars(0,clk_pix, rst_n, vga_b, vga_g, vga_hs, vga_r, vga_vs);
    end

endmodule
