`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] multiplicand;
    reg [3:0] multiplier;
    reg start;
    wire busy;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .start(start),
        .busy(busy),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            start = 0;
            multiplicand = 4'b0;
            multiplier = 4'b0;
            repeat(2) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: 3 * 2");
            reset_dut();
            multiplicand = 4'sd3;
            multiplier = 4'sd2;
            start = 1;
            @(posedge clock);
            start = 0;

            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd6);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: 7 * -4");
            reset_dut();
            multiplicand = 4'sd7;
            multiplier = -4'sd4;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'shE4);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: -5 * 6");
            reset_dut();
            multiplicand = -4'sd5;
            multiplier = 4'sd6;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'shE2);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: -7 * -3");
            reset_dut();
            multiplicand = -4'sd7;
            multiplier = -4'sd3;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd21);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: 7 * 7");
            reset_dut();
            multiplicand = 4'sd7;
            multiplier = 4'sd7;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd49);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: -8 * 7");
            reset_dut();
            multiplicand = -4'sd8;
            multiplier = 4'sd7;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'shC8);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase007: -8 * -8");
            reset_dut();
            multiplicand = -4'sd8;
            multiplier = -4'sd8;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd64);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase008: 0 * -5");
            reset_dut();
            multiplicand = 4'sd0;
            multiplier = -4'sd5;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd0);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase009: -1 * -1");
            reset_dut();
            multiplicand = -4'sd1;
            multiplier = -4'sd1;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd1);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase010: 4 * 1");
            reset_dut();
            multiplicand = 4'sd4;
            multiplier = 4'sd1;
            start = 1;
            @(posedge clock);
            start = 0;
            @(posedge clock);
            while (busy) @(posedge clock);
            #1;

            check_outputs(1'b0, 8'sd4);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_busy;
        input [7:0] expected_product;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, product=%h",
                         busy, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, product=%h",
                         expected_busy, expected_product);
                $display("  Got:      busy=%b, product=%h",
                         busy, product);
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
        $dumpvars(0,clock, multiplicand, multiplier, start, busy, product);
    end

endmodule
