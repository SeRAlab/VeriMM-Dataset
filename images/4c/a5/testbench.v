`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg idle_NormaliseProd;
    reg [49:0] productout_NormaliseProd;
    reg [32:0] zout_NormaliseProd;
    wire [31:0] FinalProduct;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .idle_NormaliseProd(idle_NormaliseProd),
        .productout_NormaliseProd(productout_NormaliseProd),
        .zout_NormaliseProd(zout_NormaliseProd),
        .FinalProduct(FinalProduct)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            idle_NormaliseProd = 1;
            productout_NormaliseProd = 50'd0;
            zout_NormaliseProd = 33'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase 001: 1.0 * 1.0 (No shift)");
            idle_NormaliseProd = 0;
            zout_NormaliseProd = {1'b0, 32'd127};
            productout_NormaliseProd = 50'h0080_0000_0000_0000;
            repeat(2) @(posedge clock);
            #1;

            check_outputs(32'h3f800000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase 002: 1.5 * 1.5 (Shift Right)");
            idle_NormaliseProd = 0;
            zout_NormaliseProd = {1'b0, 32'd127};


            productout_NormaliseProd = 50'h0120_0000_0000_0000;
            repeat(2) @(posedge clock);

            #1;


            check_outputs(32'h40100000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase 003: Negative Result (-1.0)");
            idle_NormaliseProd = 0;
            zout_NormaliseProd = {1'b1, 32'd127};
            productout_NormaliseProd = 50'h0080_0000_0000_0000;
            repeat(2) @(posedge clock);
            #1;

            check_outputs(32'hbf800000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase 004: Large Exponent (Exp=150)");
            idle_NormaliseProd = 0;
            zout_NormaliseProd = {1'b0, 32'd150};
            productout_NormaliseProd = 50'h00c0_0000_0000_0000;
            repeat(2) @(posedge clock);


            #1;



            check_outputs(32'h4b400000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase 005: Minimum Exponent (Exp=1)");
            idle_NormaliseProd = 0;
            zout_NormaliseProd = {1'b0, 32'd1};
            productout_NormaliseProd = 50'h0080_0000_0000_0000;
            repeat(2) @(posedge clock);
            #1;

            check_outputs(32'h00800000);
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
        input [31:0] expected_FinalProduct;
        begin
            if (expected_FinalProduct === (expected_FinalProduct ^ FinalProduct ^ expected_FinalProduct)) begin
                $display("PASS");
                $display("  Outputs: FinalProduct=%h",
                         FinalProduct);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FinalProduct=%h",
                         expected_FinalProduct);
                $display("  Got:      FinalProduct=%h",
                         FinalProduct);
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
        $dumpvars(0,clock, idle_NormaliseProd, productout_NormaliseProd, zout_NormaliseProd, FinalProduct);
    end

endmodule
