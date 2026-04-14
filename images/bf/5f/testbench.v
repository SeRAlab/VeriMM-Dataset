`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce_16;
    reg clock;
    reg new_tx_data;
    reg reset;
    reg [7:0] tx_data;
    wire ce_1;
    wire ser_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce_16(ce_16),
        .clock(clock),
        .new_tx_data(new_tx_data),
        .reset(reset),
        .tx_data(tx_data),
        .ce_1(ce_1),
        .ser_out(ser_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ce_16 = 0;
            new_tx_data = 0;
            tx_data = 0;
            repeat(5) @(posedge clock);
            reset = 0;
            @(posedge clock);
        end
        endtask
    task pulse_ce_16;

        begin
            @(posedge clock);
            ce_16 = 1;
            @(posedge clock);
            ce_16 = 0;

            repeat(2) @(posedge clock);
        end
        endtask

    task transmit_and_verify;

        input [7:0] data;
        integer i, j;
        begin
            $display("Starting transmission of: 8'h%h", data);
            tx_data = data;
            new_tx_data = 1;
            @(posedge clock);
            new_tx_data = 0;



            for (i = 0; i < 10; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    if (j == 8) begin
                        captured_frame[i] = ser_out;
                    end
                    pulse_ce_16();
                end
            end


            repeat(32) pulse_ce_16();


            if (captured_frame === {1'b1, data, 1'b0}) begin
                $display("  Data Frame verified: [Stop:1][Data:%b][Start:0]", data);
            end else begin
                $display("  ERROR: Captured frame mismatch! Got: %b, Expected: %b", captured_frame, {1'b1, data, 1'b0});
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial Reset and Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transmit 8'h55", test_num);
            reset_dut();
            transmit_and_verify(8'h55);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transmit 8'hAA", test_num);
            reset_dut();
            transmit_and_verify(8'hAA);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transmit 8'h00", test_num);
            reset_dut();
            transmit_and_verify(8'h00);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Transmit 8'hFF", test_num);
            reset_dut();
            transmit_and_verify(8'hFF);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_ce_1;
        input expected_ser_out;
        begin
            if (expected_ce_1 === (expected_ce_1 ^ ce_1 ^ expected_ce_1) &&
                expected_ser_out === (expected_ser_out ^ ser_out ^ expected_ser_out)) begin
                $display("PASS");
                $display("  Outputs: ce_1=%b, ser_out=%b",
                         ce_1, ser_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce_1=%b, ser_out=%b",
                         expected_ce_1, expected_ser_out);
                $display("  Got:      ce_1=%b, ser_out=%b",
                         ce_1, ser_out);
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
        $dumpvars(0,ce_16, clock, new_tx_data, reset, tx_data, ce_1, ser_out);
    end

endmodule
