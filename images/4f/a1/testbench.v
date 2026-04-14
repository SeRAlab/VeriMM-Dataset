`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] button_sel;
    reg clock;
    reg controller_data;
    reg reset;
    wire [3:0] button_data;
    wire [15:0] button_state;
    wire controller_clock;
    wire controller_latch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_sel(button_sel),
        .clock(clock),
        .controller_data(controller_data),
        .reset(reset),
        .button_data(button_data),
        .button_state(button_state),
        .controller_clock(controller_clock),
        .controller_latch(controller_latch)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            button_sel = 2'b00;
            controller_data = 0;
            repeat(5) @(posedge clock);
            #1 reset = 0;
            repeat(5) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            button_sel = 2'b00;
            fork
                provide_controller_data(16'hFFFF);
            join

            #1;


            check_outputs(4'hF, 16'hFFFF, controller_clock, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            button_sel = 2'b01;
            fork
                provide_controller_data(16'hA5A5);
            join


            #1;



            check_outputs(4'hA, 16'hA5A5, controller_clock, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            button_sel = 2'b10;
            fork
                provide_controller_data(16'h1234);
            join

            #1;


            check_outputs(4'h2, 16'h1234, controller_clock, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            button_sel = 2'b11;
            fork
                provide_controller_data(16'hABCD);
            join

            #1;


            check_outputs(4'hA, 16'hABCD, controller_clock, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            button_sel = 2'b00;
            fork
                provide_controller_data(16'h0000);
            join
            #1;

            check_outputs(4'h0, 16'h0000, controller_clock, 1'b0);
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
        input [3:0] expected_button_data;
        input [15:0] expected_button_state;
        input expected_controller_clock;
        input expected_controller_latch;
        begin
            if (expected_button_data === (expected_button_data ^ button_data ^ expected_button_data) &&
                expected_button_state === (expected_button_state ^ button_state ^ expected_button_state) &&
                expected_controller_clock === (expected_controller_clock ^ controller_clock ^ expected_controller_clock) &&
                expected_controller_latch === (expected_controller_latch ^ controller_latch ^ expected_controller_latch)) begin
                $display("PASS");
                $display("  Outputs: button_data=%h, button_state=%h, controller_clock=%b, controller_latch=%b",
                         button_data, button_state, controller_clock, controller_latch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: button_data=%h, button_state=%h, controller_clock=%b, controller_latch=%b",
                         expected_button_data, expected_button_state, expected_controller_clock, expected_controller_latch);
                $display("  Got:      button_data=%h, button_state=%h, controller_clock=%b, controller_latch=%b",
                         button_data, button_state, controller_clock, controller_latch);
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
        $dumpvars(0,button_sel, clock, controller_data, reset, button_data, button_state, controller_clock, controller_latch);
    end

endmodule
