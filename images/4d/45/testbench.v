`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] SW;
    reg [4:0] button;
    reg clk;
    wire [7:0] SW_OK;
    wire [4:0] button_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .button(button),
        .clk(clk),
        .SW_OK(SW_OK),
        .button_out(button_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting/Initializing DUT...");
            SW = 8'h00;
            button = 5'h00;

            #2000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stable High Transition", test_num);
            reset_dut();

            SW = 8'hFF;
            button = 5'h1F;


            #5000;

            #1;


            check_outputs(8'hFF, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Glitch Rejection", test_num);
            reset_dut();


            SW = 8'hAA;
            button = 5'h0A;
            #20;


            SW = 8'h00;
            button = 5'h00;
            #5000;


            #1;



            check_outputs(8'h00, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bouncing Signal Processing", test_num);
            reset_dut();


            button = 5'h01; #30;
            button = 5'h00; #20;
            button = 5'h01; #40;
            button = 5'h00; #10;
            button = 5'h01;

            #5000;

            #1;


            check_outputs(8'h00, 5'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Signal Patterns", test_num);
            reset_dut();

            SW = 8'h55;
            button = 5'h12;

            #5000;

            #1;


            check_outputs(8'h55, 5'h12);
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
        input [7:0] expected_SW_OK;
        input [4:0] expected_button_out;
        begin
            if (expected_SW_OK === (expected_SW_OK ^ SW_OK ^ expected_SW_OK) &&
                expected_button_out === (expected_button_out ^ button_out ^ expected_button_out)) begin
                $display("PASS");
                $display("  Outputs: SW_OK=%h, button_out=%h",
                         SW_OK, button_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SW_OK=%h, button_out=%h",
                         expected_SW_OK, expected_button_out);
                $display("  Got:      SW_OK=%h, button_out=%h",
                         SW_OK, button_out);
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
        $dumpvars(0,SW, button, clk, SW_OK, button_out);
    end

endmodule
