`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] InsTagMultiply;
    reg ScaleValidMultiply;
    reg clock;
    reg idle_Multiply;
    reg [49:0] productout_Multiply;
    reg [31:0] z_Multiply;
    reg [32:0] zout_Multiply;
    wire [7:0] InsTagNormaliseProd;
    wire ScaleValidNormaliseProd;
    wire idle_NormaliseProd;
    wire [49:0] productout_NormaliseProd;
    wire [31:0] z_NormaliseProd;
    wire [32:0] zout_NormaliseProd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InsTagMultiply(InsTagMultiply),
        .ScaleValidMultiply(ScaleValidMultiply),
        .clock(clock),
        .idle_Multiply(idle_Multiply),
        .productout_Multiply(productout_Multiply),
        .z_Multiply(z_Multiply),
        .zout_Multiply(zout_Multiply),
        .InsTagNormaliseProd(InsTagNormaliseProd),
        .ScaleValidNormaliseProd(ScaleValidNormaliseProd),
        .idle_NormaliseProd(idle_NormaliseProd),
        .productout_NormaliseProd(productout_NormaliseProd),
        .z_NormaliseProd(z_NormaliseProd),
        .zout_NormaliseProd(zout_NormaliseProd)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        InsTagMultiply = 0;
        ScaleValidMultiply = 0;
        idle_Multiply = 1;
        productout_Multiply = 0;
        z_Multiply = 0;
        zout_Multiply = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        InsTagMultiply = 8'hA5;
        ScaleValidMultiply = 1;
        idle_Multiply = 1;
        productout_Multiply = 50'h2AAAA_BBBBB_CCCC;
        z_Multiply = 32'h1234_5678;
        zout_Multiply = 33'h1_0000_FFFF;

        @(posedge clock);
        #2;

        $display("Testcase 001: Idle Bypass Mode");
        #1;

        check_outputs(8'hA5, 1'b1, 1'b1, 50'h2AAAA_BBBBB_CCCC, 32'h1234_5678, 33'h1_0000_FFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        InsTagMultiply = 8'h01;
        ScaleValidMultiply = 0;
        idle_Multiply = 0;

        productout_Multiply = 50'h10000_0000_0000;
        z_Multiply = 32'h0;
        zout_Multiply = 33'h0_0000_0064;

        @(posedge clock);
        #2;

        $display("Testcase 002: Active Normalization (Shift Right Case)");


        #1;



        check_outputs(8'h01, 1'b0, 1'b0, 50'h08000_0000_0000, 32'h0, 33'h0_0000_0065);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        InsTagMultiply = 8'h02;
        ScaleValidMultiply = 0;
        idle_Multiply = 0;
        productout_Multiply = 50'h08000_0000_0000;
        z_Multiply = 32'hFFFF_FFFF;
        zout_Multiply = 33'h0_0000_0064;

        @(posedge clock);
        #2;

        $display("Testcase 003: Active Mode (No shift required)");
        #1;

        check_outputs(8'h02, 1'b0, 1'b0, 50'h08000_0000_0000, 32'hFFFF_FFFF, 33'h0_0000_0064);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        InsTagMultiply = 8'hFF;
        ScaleValidMultiply = 1;
        idle_Multiply = 0;
        productout_Multiply = 50'h00000_0000_0001;
        z_Multiply = 32'hAAAA_5555;
        zout_Multiply = 33'h1_FFFF_FFFF;

        @(posedge clock);
        #2;

        $display("Testcase 004: Tag and Scale Signal Propagation");


        if (InsTagNormaliseProd === 8'hFF && idle_NormaliseProd === 1'b0)
             $display("PASS: Control signals propagated");
        else
             $display("FAIL: Control signals mismatch");


        #1;



        check_outputs(InsTagNormaliseProd, ScaleValidNormaliseProd, 1'b0, productout_NormaliseProd, 32'hAAAA_5555, zout_NormaliseProd);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        InsTagMultiply = 8'h00;
        ScaleValidMultiply = 0;
        idle_Multiply = 0;
        productout_Multiply = 50'h0;
        z_Multiply = 32'h0;
        zout_Multiply = 33'h0;

        @(posedge clock);
        #2;

        $display("Testcase 005: Zero Input Active Mode");
        #1;

        check_outputs(8'h00, 1'b0, 1'b0, 50'h0, 32'h0, 33'h0);
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
        input [7:0] expected_InsTagNormaliseProd;
        input expected_ScaleValidNormaliseProd;
        input expected_idle_NormaliseProd;
        input [49:0] expected_productout_NormaliseProd;
        input [31:0] expected_z_NormaliseProd;
        input [32:0] expected_zout_NormaliseProd;
        begin
            if (expected_InsTagNormaliseProd === (expected_InsTagNormaliseProd ^ InsTagNormaliseProd ^ expected_InsTagNormaliseProd) &&
                expected_ScaleValidNormaliseProd === (expected_ScaleValidNormaliseProd ^ ScaleValidNormaliseProd ^ expected_ScaleValidNormaliseProd) &&
                expected_idle_NormaliseProd === (expected_idle_NormaliseProd ^ idle_NormaliseProd ^ expected_idle_NormaliseProd) &&
                expected_productout_NormaliseProd === (expected_productout_NormaliseProd ^ productout_NormaliseProd ^ expected_productout_NormaliseProd) &&
                expected_z_NormaliseProd === (expected_z_NormaliseProd ^ z_NormaliseProd ^ expected_z_NormaliseProd) &&
                expected_zout_NormaliseProd === (expected_zout_NormaliseProd ^ zout_NormaliseProd ^ expected_zout_NormaliseProd)) begin
                $display("PASS");
                $display("  Outputs: InsTagNormaliseProd=%h, ScaleValidNormaliseProd=%b, idle_NormaliseProd=%b, productout_NormaliseProd=%h, z_NormaliseProd=%h, zout_NormaliseProd=%h",
                         InsTagNormaliseProd, ScaleValidNormaliseProd, idle_NormaliseProd, productout_NormaliseProd, z_NormaliseProd, zout_NormaliseProd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InsTagNormaliseProd=%h, ScaleValidNormaliseProd=%b, idle_NormaliseProd=%b, productout_NormaliseProd=%h, z_NormaliseProd=%h, zout_NormaliseProd=%h",
                         expected_InsTagNormaliseProd, expected_ScaleValidNormaliseProd, expected_idle_NormaliseProd, expected_productout_NormaliseProd, expected_z_NormaliseProd, expected_zout_NormaliseProd);
                $display("  Got:      InsTagNormaliseProd=%h, ScaleValidNormaliseProd=%b, idle_NormaliseProd=%b, productout_NormaliseProd=%h, z_NormaliseProd=%h, zout_NormaliseProd=%h",
                         InsTagNormaliseProd, ScaleValidNormaliseProd, idle_NormaliseProd, productout_NormaliseProd, z_NormaliseProd, zout_NormaliseProd);
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
        $dumpvars(0,InsTagMultiply, ScaleValidMultiply, clock, idle_Multiply, productout_Multiply, z_Multiply, zout_Multiply, InsTagNormaliseProd, ScaleValidNormaliseProd, idle_NormaliseProd, productout_NormaliseProd, z_NormaliseProd, zout_NormaliseProd);
    end

endmodule
