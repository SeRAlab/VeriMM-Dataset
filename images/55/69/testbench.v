`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Cr_Cb_N;
    reg clk;
    reg [23:0] s444_data;
    reg s444_de;
    reg [15:0] s444_sync;
    wire [15:0] s422_data;
    wire [15:0] s422_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cr_Cb_N(Cr_Cb_N),
        .clk(clk),
        .s444_data(s444_data),
        .s444_de(s444_de),
        .s444_sync(s444_sync),
        .s422_data(s422_data),
        .s422_sync(s422_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Cr_Cb_N = 0;
            s444_data = 0;
            s444_de = 0;
            s444_sync = 0;
            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Cb averaging (Cr_Cb_N = 0)");

            s444_de = 1; Cr_Cb_N = 0; s444_sync = 16'h1000; s444_data = {8'hAA, 8'd30, 8'd0};
            @(posedge clk); #1;
            s444_sync = 16'h2000; s444_data = {8'hBB, 8'd60, 8'd0};
            @(posedge clk); #1;
            s444_sync = 16'h3000; s444_data = {8'hCC, 8'd90, 8'd0};
            @(posedge clk); #1;

            #1;


            check_outputs(16'hCC3C, 16'h3000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Cr averaging (Cr_Cb_N = 1)");

            s444_de = 1; Cr_Cb_N = 1; s444_sync = 16'hAAAA; s444_data = {8'h11, 8'd0, 8'd10};
            @(posedge clk); #1;
            s444_sync = 16'hBBBB; s444_data = {8'h22, 8'd0, 8'd20};
            @(posedge clk); #1;
            s444_sync = 16'hCCCC; s444_data = {8'h33, 8'd0, 8'd30};
            @(posedge clk); #1;

            #1;


            check_outputs(16'h3314, 16'hCCCC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Full scale input (0xFF)");
            s444_de = 1; Cr_Cb_N = 0; s444_sync = 16'hFFFF; s444_data = 24'hFFFFFF;
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Moving window check");
            s444_de = 1; Cr_Cb_N = 0;

            s444_data = {8'h01, 8'd100, 8'd0}; @(posedge clk); #1;

            s444_data = {8'h02, 8'd100, 8'd0}; @(posedge clk); #1;

            s444_data = {8'h03, 8'd100, 8'd0}; @(posedge clk); #1;

            s444_data = {8'h04, 8'd25, 8'd0}; s444_sync = 16'h4444;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h044B, 16'h4444);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Integer division check (31/3 = 10)");
            s444_de = 1; Cr_Cb_N = 1; s444_sync = 16'h5555;
            s444_data = {8'hFF, 8'd0, 8'd10}; @(posedge clk); #1;
            s444_data = {8'hFF, 8'd0, 8'd10}; @(posedge clk); #1;
            s444_data = {8'hA1, 8'd0, 8'd11}; @(posedge clk); #1;

            #1;


            check_outputs(16'hA10A, 16'h5555);
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
        input [15:0] expected_s422_data;
        input [15:0] expected_s422_sync;
        begin
            if (expected_s422_data === (expected_s422_data ^ s422_data ^ expected_s422_data) &&
                expected_s422_sync === (expected_s422_sync ^ s422_sync ^ expected_s422_sync)) begin
                $display("PASS");
                $display("  Outputs: s422_data=%h, s422_sync=%h",
                         s422_data, s422_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s422_data=%h, s422_sync=%h",
                         expected_s422_data, expected_s422_sync);
                $display("  Got:      s422_data=%h, s422_sync=%h",
                         s422_data, s422_sync);
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
        $dumpvars(0,Cr_Cb_N, clk, s444_data, s444_de, s444_sync, s422_data, s422_sync);
    end

endmodule
