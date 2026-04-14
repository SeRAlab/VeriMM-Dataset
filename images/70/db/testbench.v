`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] multiplicand;
    reg [3:0] multiplier;
    reg reset;
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
        .reset(reset),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;

            repeat (5) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            multiplicand = 4'd3;
            multiplier = 4'd2;
            reset_dut();
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            multiplicand = 4'sd3;
            multiplier = -4'sd2;
            reset_dut();
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            multiplicand = -4'sd3;
            multiplier = 4'sd2;
            reset_dut();
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            multiplicand = -4'sd3;
            multiplier = -4'sd2;
            reset_dut();
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            multiplicand = 4'sd7;
            multiplier = 4'sd7;
            reset_dut();
            #1;

            check_outputs(8'sd49);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            multiplicand = -4'sd8;
            multiplier = 4'sd7;
            reset_dut();
            #1;

            check_outputs(-8'sd56);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            multiplicand = -4'sd8;
            multiplier = -4'sd8;
            reset_dut();
            #1;

            check_outputs(8'sd64);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            multiplicand = 4'sd0;
            multiplier = -4'sd5;
            reset_dut();
            #1;

            check_outputs(8'sd0);
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
        input [7:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,clock, multiplicand, multiplier, reset, product);
    end

endmodule
