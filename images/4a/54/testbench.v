`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [8:0] cos_i;
    reg dv0_i;
    reg dv1_i;
    reg dv2_i;
    reg [7:0] pix01_i;
    reg [7:0] pix10_i;
    reg [7:0] pix12_i;
    reg [7:0] pix21_i;
    reg reset_n_i;
    reg sclr_i;
    reg [8:0] sin_i;
    wire [18:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .cos_i(cos_i),
        .dv0_i(dv0_i),
        .dv1_i(dv1_i),
        .dv2_i(dv2_i),
        .pix01_i(pix01_i),
        .pix10_i(pix10_i),
        .pix12_i(pix12_i),
        .pix21_i(pix21_i),
        .reset_n_i(reset_n_i),
        .sclr_i(sclr_i),
        .sin_i(sin_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        reset_n_i = 0;
        sclr_i = 0;
        dv0_i = 0;
        dv1_i = 0;
        dv2_i = 0;
        pix01_i = 0;
        pix10_i = 0;
        pix12_i = 0;
        pix21_i = 0;
        cos_i = 0;
        sin_i = 0;
        repeat(5) @(posedge clk_i);
        #1 reset_n_i = 1;
        repeat(2) @(posedge clk_i);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: All zeros...");
        reset_dut();
        test_num = 1;

        dv0_i = 1; dv1_i = 1; dv2_i = 1;
        pix01_i = 0; pix10_i = 0; pix12_i = 0; pix21_i = 0;
        cos_i = 0; sin_i = 0;

        repeat(10) @(posedge clk_i);
        #1;

        check_outputs(19'h00000);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single component check...");
        reset_dut();
        test_num = 2;

        dv0_i = 1; dv1_i = 1; dv2_i = 1;
        pix10_i = 8'd10;
        cos_i = 9'd5;


        repeat(10) @(posedge clk_i);
        #1;

        check_outputs(19'h00032);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Combined matrix elements...");
        reset_dut();
        test_num = 3;

        dv0_i = 1; dv1_i = 1; dv2_i = 1;
        pix01_i = 8'd2;
        pix10_i = 8'd4;
        pix12_i = 8'd6;
        pix21_i = 8'd8;
        cos_i = 9'd10;
        sin_i = 9'd5;


        repeat(10) @(posedge clk_i);
        #1;

        check_outputs(19'h000A0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Large value check...");
        reset_dut();
        test_num = 4;

        dv0_i = 1; dv1_i = 1; dv2_i = 1;
        pix01_i = 8'd100;
        pix10_i = 8'd100;
        pix12_i = 8'd100;
        pix21_i = 8'd100;
        cos_i = 9'd200;
        sin_i = 9'd100;


        repeat(10) @(posedge clk_i);
        #1;

        check_outputs(19'h0EA60);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Synchronous clear check...");
        reset_dut();
        test_num = 5;

        dv0_i = 1; dv1_i = 1; dv2_i = 1;
        pix10_i = 8'd50;
        cos_i = 9'd10;

        repeat(2) @(posedge clk_i);
        sclr_i = 1;
        repeat(1) @(posedge clk_i);
        sclr_i = 0;

        repeat(10) @(posedge clk_i);

        #1;


        check_outputs(19'h00000);
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
        input [18:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,clk_i, cos_i, dv0_i, dv1_i, dv2_i, pix01_i, pix10_i, pix12_i, pix21_i, reset_n_i, sclr_i, sin_i, data_o);
    end

endmodule
