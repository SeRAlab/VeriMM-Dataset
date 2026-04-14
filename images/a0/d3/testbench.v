`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg brdsprt;
    reg clk;
    reg data_in;
    reg reg_address_in;
    reg reset;
    reg sprsel;
    reg window_ena;
    wire [7:0] blue;
    wire [7:0] green;
    wire [7:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .brdsprt(brdsprt),
        .clk(clk),
        .data_in(data_in),
        .reg_address_in(reg_address_in),
        .reset(reset),
        .sprsel(sprsel),
        .window_ena(window_ena),
        .blue(blue),
        .green(green),
        .red(red)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            brdsprt = 0;
            data_in = 0;
            reg_address_in = 0;
            sprsel = 0;
            window_ena = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Idle State");
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Window Enable");
            reset_dut();
            window_ena = 1;
            repeat (5) @(posedge clk);



            #1;




            check_outputs(blue, green, red);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Border Sprite Control");
            reset_dut();
            window_ena = 1;
            brdsprt = 1;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(blue, green, red);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Sprite Selection");
            reset_dut();
            window_ena = 1;
            sprsel = 1;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(blue, green, red);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning Testcase 005: Serial Config Interface");
            reset_dut();
            window_ena = 1;

            for (i = 0; i < 8; i = i + 1) begin
                reg_address_in = i[0];
                data_in = ~i[0];
                @(posedge clk);
            end
            #1;

            check_outputs(blue, green, red);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Combined Window, Sprite, and Border");
            reset_dut();
            window_ena = 1;
            brdsprt = 1;
            sprsel = 1;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(blue, green, red);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Blanking (Window Disabled)");
            reset_dut();
            window_ena = 0;
            brdsprt = 1;
            sprsel = 1;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_blue;
        input [7:0] expected_green;
        input [7:0] expected_red;
        begin
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, red=%h",
                         blue, green, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, red=%h",
                         expected_blue, expected_green, expected_red);
                $display("  Got:      blue=%h, green=%h, red=%h",
                         blue, green, red);
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
        $dumpvars(0,brdsprt, clk, data_in, reg_address_in, reset, sprsel, window_ena, blue, green, red);
    end

endmodule
