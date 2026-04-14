`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ir_signal;
    wire [7:0] command;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ir_signal(ir_signal),
        .command(command)
    );

    // Clock generation (10ns period)
    initial begin
        ir_signal = 0;
        forever #5 ir_signal = ~ir_signal;
    end

        task reset_dut;

        begin
            ir_signal = 1;
            #200;
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            ir_signal = 0;
            #100;


            for (i = 0; i < 8; i = i + 1) begin
                ir_signal = data[i];
                #100;
            end


            ir_signal = 1;
            #100;


            #20;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase 001: Sending Command 0xA5");
            reset_dut();
            send_byte(8'hA5);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase 002: Sending Command 0x5A");
            reset_dut();
            send_byte(8'h5A);
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase 003: Sending Command 0xFF");
            reset_dut();
            send_byte(8'hFF);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase 004: Sending Command 0x00");
            reset_dut();
            send_byte(8'h00);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase 005: Sending Command 0xC3");
            reset_dut();
            send_byte(8'hC3);
            #1;

            check_outputs(8'hC3);
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
        input [7:0] expected_command;
        begin
            if (expected_command === (expected_command ^ command ^ expected_command)) begin
                $display("PASS");
                $display("  Outputs: command=%h",
                         command);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command=%h",
                         expected_command);
                $display("  Got:      command=%h",
                         command);
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
        $dumpvars(0,ir_signal, command);
    end

endmodule
