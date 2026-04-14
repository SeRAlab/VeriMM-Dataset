`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable_in;
    reg [15:0] x;
    reg [15:0] y;
    wire enable_out;
    wire [30:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable_in(enable_in),
        .x(x),
        .y(y),
        .enable_out(enable_out),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable_in = 0;
            x = 0;
            y = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            x = 16'sd100;
            y = 16'sd50;
            enable_in = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 31'sd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            x = 16'sd12;
            y = 16'sd10;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 31'sd120);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            x = 16'sd25;
            y = -16'sd4;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, -31'sd100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            x = -16'sd15;
            y = -16'sd3;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 31'sd45);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            x = 16'sd0;
            y = 16'sd999;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 31'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            x = 16'sh7FFF;
            y = 16'sh7FFF;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 31'sd1073676289);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            x = 16'sh8000;
            y = 16'sh7FFF;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, -31'sd1073709056);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            x = 16'sh8000;
            y = 16'sh8000;
            enable_in = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 31'sh40000000);
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
        input expected_enable_out;
        input [30:0] expected_product;
        begin
            if (expected_enable_out === (expected_enable_out ^ enable_out ^ expected_enable_out) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: enable_out=%b, product=%h",
                         enable_out, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_out=%b, product=%h",
                         expected_enable_out, expected_product);
                $display("  Got:      enable_out=%b, product=%h",
                         enable_out, product);
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
        $dumpvars(0,clock, enable_in, x, y, enable_out, product);
    end

endmodule
