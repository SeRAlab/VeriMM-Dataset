`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg char;
    reg clock;
    wire [3:0] keyboard_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .char(char),
        .clock(clock),
        .keyboard_data(keyboard_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            char = 0;
            repeat (10) @(posedge clock);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clock);
                char = data[i];
            end

            @(posedge clock);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Sending character 0x1C...", test_num);
            reset_dut();
            send_byte(8'h1C);

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Sending character 0x1D...", test_num);
            reset_dut();
            send_byte(8'h1D);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Sending character 0x1B...", test_num);
            reset_dut();
            send_byte(8'h1B);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Sending character 0x23...", test_num);
            reset_dut();
            send_byte(8'h23);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Sending back-to-back 0x1C and 0x23...", test_num);
            reset_dut();
            send_byte(8'h1C);
            send_byte(8'h23);
            #1;

            check_outputs(4'h4);
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
        input [3:0] expected_keyboard_data;
        begin
            if (expected_keyboard_data === (expected_keyboard_data ^ keyboard_data ^ expected_keyboard_data)) begin
                $display("PASS");
                $display("  Outputs: keyboard_data=%h",
                         keyboard_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keyboard_data=%h",
                         expected_keyboard_data);
                $display("  Got:      keyboard_data=%h",
                         keyboard_data);
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
        $dumpvars(0,char, clock, keyboard_data);
    end

endmodule
