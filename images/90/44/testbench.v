`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg idle_Multiply;
    reg [49:0] productout_Multiply;
    reg [32:0] zout_Multiply;
    wire idle_NormaliseProd;
    wire [49:0] productout_NormaliseProd;
    wire [32:0] zout_NormaliseProd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .idle_Multiply(idle_Multiply),
        .productout_Multiply(productout_Multiply),
        .zout_Multiply(zout_Multiply),
        .idle_NormaliseProd(idle_NormaliseProd),
        .productout_NormaliseProd(productout_NormaliseProd),
        .zout_NormaliseProd(zout_NormaliseProd)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            idle_Multiply = 1;
            productout_Multiply = 50'd0;
            zout_Multiply = 33'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            idle_Multiply = 0;
            productout_Multiply = 50'h0_8000_0000_0000;
            zout_Multiply = 33'h0_0000_0100;
            @(posedge clock);
            #2;

            #1;


            check_outputs(0, 50'h0_8000_0000_0000, 33'h0_0000_0100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            idle_Multiply = 0;
            productout_Multiply = 50'h1_0000_0000_0000;
            zout_Multiply = 33'h0_0000_0100;
            @(posedge clock);
            #2;

            #1;


            check_outputs(0, 50'h0_8000_0000_0000, 33'h0_0000_0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            idle_Multiply = 1;
            productout_Multiply = 50'h0_FFFF_FFFF_FFFF;
            zout_Multiply = 33'h1_AAAA_AAAA;
            @(posedge clock);
            #2;

            #1;


            check_outputs(1, 50'h0_FFFF_FFFF_FFFF, 33'h1_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            idle_Multiply = 0;
            productout_Multiply = 50'h1_AAAA_5555_AAAA;
            zout_Multiply = 33'h1_FFFF_FFFF;
            @(posedge clock);
            #2;

            #1;


            check_outputs(0, 50'h0_D555_2AAA_5555, 33'h0_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            idle_Multiply = 0;
            productout_Multiply = 50'h0;
            zout_Multiply = 33'h0_0000_0050;
            @(posedge clock);
            #2;

            #1;


            check_outputs(0, 50'h0, 33'h0_0000_0050);
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
        input expected_idle_NormaliseProd;
        input [49:0] expected_productout_NormaliseProd;
        input [32:0] expected_zout_NormaliseProd;
        begin
            if (expected_idle_NormaliseProd === (expected_idle_NormaliseProd ^ idle_NormaliseProd ^ expected_idle_NormaliseProd) &&
                expected_productout_NormaliseProd === (expected_productout_NormaliseProd ^ productout_NormaliseProd ^ expected_productout_NormaliseProd) &&
                expected_zout_NormaliseProd === (expected_zout_NormaliseProd ^ zout_NormaliseProd ^ expected_zout_NormaliseProd)) begin
                $display("PASS");
                $display("  Outputs: idle_NormaliseProd=%b, productout_NormaliseProd=%h, zout_NormaliseProd=%h",
                         idle_NormaliseProd, productout_NormaliseProd, zout_NormaliseProd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: idle_NormaliseProd=%b, productout_NormaliseProd=%h, zout_NormaliseProd=%h",
                         expected_idle_NormaliseProd, expected_productout_NormaliseProd, expected_zout_NormaliseProd);
                $display("  Got:      idle_NormaliseProd=%b, productout_NormaliseProd=%h, zout_NormaliseProd=%h",
                         idle_NormaliseProd, productout_NormaliseProd, zout_NormaliseProd);
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
        $dumpvars(0,clock, idle_Multiply, productout_Multiply, zout_Multiply, idle_NormaliseProd, productout_NormaliseProd, zout_NormaliseProd);
    end

endmodule
