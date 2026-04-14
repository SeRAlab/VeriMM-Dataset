`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [32:0] aout_Special;
    reg [32:0] bout_Special;
    reg clock;
    reg idle_Special;
    reg [32:0] zout_Special;
    wire idle_Multiply;
    wire [49:0] productout_Multiply;
    wire [32:0] zout_Multiply;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aout_Special(aout_Special),
        .bout_Special(bout_Special),
        .clock(clock),
        .idle_Special(idle_Special),
        .zout_Special(zout_Special),
        .idle_Multiply(idle_Multiply),
        .productout_Multiply(productout_Multiply),
        .zout_Multiply(zout_Multiply)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            aout_Special = 33'h0;
            bout_Special = 33'h0;
            zout_Special = 33'h0;
            idle_Special = 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            aout_Special = 33'h07F800000;
            bout_Special = 33'h07F800000;
            idle_Special = 1'b0;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase %0d: 1.0 * 1.0", test_num);
            #1;

            check_outputs(1'b0, 50'h0400000000000, 33'h07F800000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            aout_Special = 33'h080800000;
            bout_Special = 33'h07FC00000;
            idle_Special = 1'b0;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase %0d: 2.0 * 1.5", test_num);
            #1;

            check_outputs(1'b0, 50'h0600000000000, 33'h080C00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            aout_Special = 33'h180800000;
            bout_Special = 33'h081800000;
            idle_Special = 1'b0;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase %0d: -2.0 * 4.0", test_num);
            #1;

            check_outputs(1'b0, 50'h0400000000000, 33'h182800000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            aout_Special = 33'h07FC00000;
            bout_Special = 33'h07FC00000;
            idle_Special = 1'b0;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase %0d: 1.5 * 1.5 (Normalization)", test_num);
            #1;

            check_outputs(1'b0, 50'h0900000000000, 33'h080900000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            aout_Special = 33'h07E800000;
            bout_Special = 33'h07E800000;
            idle_Special = 1'b0;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase %0d: 0.5 * 0.5", test_num);
            #1;

            check_outputs(1'b0, 50'h0400000000000, 33'h07D800000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            idle_Special = 1'b1;
            zout_Special = 33'h1ABCDEF01;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase %0d: Idle State", test_num);
            #1;

            check_outputs(1'b1, 50'h0, 33'h1ABCDEF01);
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
        input expected_idle_Multiply;
        input [49:0] expected_productout_Multiply;
        input [32:0] expected_zout_Multiply;
        begin
            if (expected_idle_Multiply === (expected_idle_Multiply ^ idle_Multiply ^ expected_idle_Multiply) &&
                expected_productout_Multiply === (expected_productout_Multiply ^ productout_Multiply ^ expected_productout_Multiply) &&
                expected_zout_Multiply === (expected_zout_Multiply ^ zout_Multiply ^ expected_zout_Multiply)) begin
                $display("PASS");
                $display("  Outputs: idle_Multiply=%b, productout_Multiply=%h, zout_Multiply=%h",
                         idle_Multiply, productout_Multiply, zout_Multiply);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: idle_Multiply=%b, productout_Multiply=%h, zout_Multiply=%h",
                         expected_idle_Multiply, expected_productout_Multiply, expected_zout_Multiply);
                $display("  Got:      idle_Multiply=%b, productout_Multiply=%h, zout_Multiply=%h",
                         idle_Multiply, productout_Multiply, zout_Multiply);
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
        $dumpvars(0,aout_Special, bout_Special, clock, idle_Special, zout_Special, idle_Multiply, productout_Multiply, zout_Multiply);
    end

endmodule
