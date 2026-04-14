`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] InsTagSpecial;
    reg ScaleValidSpecial;
    reg [32:0] aout_Special;
    reg [32:0] bout_Special;
    reg clock;
    reg idle_Special;
    reg [31:0] z_Special;
    reg [32:0] zout_Special;
    wire [7:0] InsTagMultiply;
    wire ScaleValidMultiply;
    wire idle_Multiply;
    wire [49:0] productout_Multiply;
    wire [31:0] z_Multiply;
    wire [32:0] zout_Multiply;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InsTagSpecial(InsTagSpecial),
        .ScaleValidSpecial(ScaleValidSpecial),
        .aout_Special(aout_Special),
        .bout_Special(bout_Special),
        .clock(clock),
        .idle_Special(idle_Special),
        .z_Special(z_Special),
        .zout_Special(zout_Special),
        .InsTagMultiply(InsTagMultiply),
        .ScaleValidMultiply(ScaleValidMultiply),
        .idle_Multiply(idle_Multiply),
        .productout_Multiply(productout_Multiply),
        .z_Multiply(z_Multiply),
        .zout_Multiply(zout_Multiply)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            InsTagSpecial = 8'h0;
            ScaleValidSpecial = 1'b0;
            aout_Special = 33'h0;
            bout_Special = 33'h0;
            idle_Special = 1'b0;
            z_Special = 32'h0;
            zout_Special = 33'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Zeros and Reset Check");
            test_num = test_num + 1;
            reset_dut();

            aout_Special = 33'd0;
            bout_Special = 33'd0;
            zout_Special = 33'd0;
            z_Special = 32'd0;
            InsTagSpecial = 8'h00;
            ScaleValidSpecial = 1'b0;
            idle_Special = 1'b0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0, 50'd0, 32'd0, 33'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Simple Multiplication (7 * 8)");
            test_num = test_num + 1;
            reset_dut();

            aout_Special = 33'd7;
            bout_Special = 33'd8;
            InsTagSpecial = 8'hA1;
            ScaleValidSpecial = 1'b1;

            @(posedge clock);
            #1;

            #1;


            check_outputs(8'hA1, 1'b1, 1'b0, 50'd56, 32'd0, 33'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Large Multiplication and Pass-through Data");
            test_num = test_num + 1;
            reset_dut();


            aout_Special = 33'h00010000;
            bout_Special = 33'h00010000;
            zout_Special = 33'h1AAAAAAAA;
            z_Special = 32'hDEADBEEF;
            InsTagSpecial = 8'h55;
            idle_Special = 1'b1;

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h55, 1'b0, 1'b1, 50'h000100000000, 32'hDEADBEEF, 33'h1AAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Product Truncation (50-bit limit)");
            test_num = test_num + 1;
            reset_dut();



            aout_Special = 33'h02000000;
            bout_Special = 33'h02000000;

            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h00, 1'b0, 1'b0, 50'h0, 32'h0, 33'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Max Input Values check");
            test_num = test_num + 1;
            reset_dut();

            aout_Special = 33'h1FFFFFFFF;
            bout_Special = 33'h000000002;
            InsTagSpecial = 8'hFF;
            ScaleValidSpecial = 1'b1;

            @(posedge clock);
            #1;

            #1;


            check_outputs(8'hFF, 1'b1, 1'b0, 50'h00003FFFFFFFE, 32'h0, 33'h0);
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
        input [7:0] expected_InsTagMultiply;
        input expected_ScaleValidMultiply;
        input expected_idle_Multiply;
        input [49:0] expected_productout_Multiply;
        input [31:0] expected_z_Multiply;
        input [32:0] expected_zout_Multiply;
        begin
            if (expected_InsTagMultiply === (expected_InsTagMultiply ^ InsTagMultiply ^ expected_InsTagMultiply) &&
                expected_ScaleValidMultiply === (expected_ScaleValidMultiply ^ ScaleValidMultiply ^ expected_ScaleValidMultiply) &&
                expected_idle_Multiply === (expected_idle_Multiply ^ idle_Multiply ^ expected_idle_Multiply) &&
                expected_productout_Multiply === (expected_productout_Multiply ^ productout_Multiply ^ expected_productout_Multiply) &&
                expected_z_Multiply === (expected_z_Multiply ^ z_Multiply ^ expected_z_Multiply) &&
                expected_zout_Multiply === (expected_zout_Multiply ^ zout_Multiply ^ expected_zout_Multiply)) begin
                $display("PASS");
                $display("  Outputs: InsTagMultiply=%h, ScaleValidMultiply=%b, idle_Multiply=%b, productout_Multiply=%h, z_Multiply=%h, zout_Multiply=%h",
                         InsTagMultiply, ScaleValidMultiply, idle_Multiply, productout_Multiply, z_Multiply, zout_Multiply);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InsTagMultiply=%h, ScaleValidMultiply=%b, idle_Multiply=%b, productout_Multiply=%h, z_Multiply=%h, zout_Multiply=%h",
                         expected_InsTagMultiply, expected_ScaleValidMultiply, expected_idle_Multiply, expected_productout_Multiply, expected_z_Multiply, expected_zout_Multiply);
                $display("  Got:      InsTagMultiply=%h, ScaleValidMultiply=%b, idle_Multiply=%b, productout_Multiply=%h, z_Multiply=%h, zout_Multiply=%h",
                         InsTagMultiply, ScaleValidMultiply, idle_Multiply, productout_Multiply, z_Multiply, zout_Multiply);
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
        $dumpvars(0,InsTagSpecial, ScaleValidSpecial, aout_Special, bout_Special, clock, idle_Special, z_Special, zout_Special, InsTagMultiply, ScaleValidMultiply, idle_Multiply, productout_Multiply, z_Multiply, zout_Multiply);
    end

endmodule
