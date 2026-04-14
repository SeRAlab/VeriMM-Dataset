`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] button_sel;
    reg clock;
    reg controller_data;
    reg reset;
    wire [3:0] button_data;
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
            button_sel = 0;
            controller_data = 0;
            stream_active = 0;
            repeat (10) @(posedge clock);
            reset = 0;
            repeat (5) @(posedge clock);
        end
        endtask
    task send_snes_stream;

        input [15:0] pattern;
        integer i;
        begin
            stream_active = 1;

            @(posedge controller_latch);

            controller_data = pattern[0];
            @(negedge controller_latch);


            for (i = 1; i < 16; i = i + 1) begin
                @(negedge controller_clock);
                controller_data = pattern[i];
            end


            repeat (20) @(posedge clock);
            stream_active = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reading Nibble 0 (Bits 3:0)", test_num);
            reset_dut();
            button_sel = 2'b00;

            fork
                send_snes_stream(16'h8421);
            join_none

            wait(stream_active == 1);
            wait(stream_active == 0);


            #1;



            check_outputs(4'h1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reading Nibble 1 (Bits 7:4)", test_num);
            reset_dut();
            button_sel = 2'b01;

            fork
                send_snes_stream(16'h8421);
            join_none

            wait(stream_active == 1);
            wait(stream_active == 0);

            #1;


            check_outputs(4'h2, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reading Nibble 2 (Bits 11:8)", test_num);
            reset_dut();
            button_sel = 2'b10;

            fork
                send_snes_stream(16'h8421);
            join_none

            wait(stream_active == 1);
            wait(stream_active == 0);

            #1;


            check_outputs(4'h4, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reading Nibble 3 (Bits 15:12)", test_num);
            reset_dut();
            button_sel = 2'b11;

            fork
                send_snes_stream(16'h8421);
            join_none

            wait(stream_active == 1);
            wait(stream_active == 0);

            #1;


            check_outputs(4'h8, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verification with complex pattern (0xCAFE)", test_num);
            reset_dut();
            button_sel = 2'b00;

            fork
                send_snes_stream(16'hCAFE);
            join_none

            wait(stream_active == 1);
            wait(stream_active == 0);

            #1;


            check_outputs(4'hE, 1'b1, 1'b0);
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
        input expected_controller_clock;
        input expected_controller_latch;
        begin
            if (expected_button_data === (expected_button_data ^ button_data ^ expected_button_data) &&
                expected_controller_clock === (expected_controller_clock ^ controller_clock ^ expected_controller_clock) &&
                expected_controller_latch === (expected_controller_latch ^ controller_latch ^ expected_controller_latch)) begin
                $display("PASS");
                $display("  Outputs: button_data=%h, controller_clock=%b, controller_latch=%b",
                         button_data, controller_clock, controller_latch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: button_data=%h, controller_clock=%b, controller_latch=%b",
                         expected_button_data, expected_controller_clock, expected_controller_latch);
                $display("  Got:      button_data=%h, controller_clock=%b, controller_latch=%b",
                         button_data, controller_clock, controller_latch);
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
        $dumpvars(0,button_sel, clock, controller_data, reset, button_data, controller_clock, controller_latch);
    end

endmodule
