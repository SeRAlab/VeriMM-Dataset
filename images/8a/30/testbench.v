`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] SW;
    reg [4:0] button;
    reg clk;
    wire [7:0] SW_OK;
    wire [4:0] button_out;
    wire [4:0] button_pulse;

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
        .button_out(button_out),
        .button_pulse(button_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SW = 8'h00;
            button = 5'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switch Pass-through", test_num);
            reset_dut();
            SW = 8'hA5;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Button Press Stabilization", test_num);
            reset_dut();
            button = 5'b00001;


            repeat(1024) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h00, 5'b00001, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Glitch Rejection", test_num);
            reset_dut();
            button = 5'b00010;
            repeat(10) @(posedge clk);
            button = 5'b00000;
            repeat(100) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 5'b00000, 5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Button Release Debouncing", test_num);
            reset_dut();

            button = 5'b00100;
            repeat(1024) @(posedge clk);
            #1;

            button = 5'b00000;
            repeat(1024) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 5'b00000, 5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Buttons and Switches", test_num);
            reset_dut();
            SW = 8'hFF;
            button = 5'b10001;
            repeat(1024) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 5'b10001, 5'b00000);
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
        input [4:0] expected_button_pulse;
        begin
            if (expected_SW_OK === (expected_SW_OK ^ SW_OK ^ expected_SW_OK) &&
                expected_button_out === (expected_button_out ^ button_out ^ expected_button_out) &&
                expected_button_pulse === (expected_button_pulse ^ button_pulse ^ expected_button_pulse)) begin
                $display("PASS");
                $display("  Outputs: SW_OK=%h, button_out=%h, button_pulse=%h",
                         SW_OK, button_out, button_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SW_OK=%h, button_out=%h, button_pulse=%h",
                         expected_SW_OK, expected_button_out, expected_button_pulse);
                $display("  Got:      SW_OK=%h, button_out=%h, button_pulse=%h",
                         SW_OK, button_out, button_pulse);
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
        $dumpvars(0,SW, button, clk, SW_OK, button_out, button_pulse);
    end

endmodule
