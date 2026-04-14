`timescale 1ns/1ps

module Piezo_Driver_tb;

    // Testbench signals (sequential circuit)
    reg Write;
    reg clock;
    reg [24:0] data;
    reg reset;
    wire Ack;
    wire Piezo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Piezo_Driver dut (
        .Write(Write),
        .clock(clock),
        .data(data),
        .reset(reset),
        .Ack(Ack),
        .Piezo(Piezo)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Piezo_Driver Testbench");
        $display("========================================");


        
        
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
        input expected_Ack;
        input expected_Piezo;
        begin
            if (expected_Ack === (expected_Ack ^ Ack ^ expected_Ack) &&
                expected_Piezo === (expected_Piezo ^ Piezo ^ expected_Piezo)) begin
                $display("PASS");
                $display("  Outputs: Ack=%b, Piezo=%b",
                         Ack, Piezo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ack=%b, Piezo=%b",
                         expected_Ack, expected_Piezo);
                $display("  Got:      Ack=%b, Piezo=%b",
                         Ack, Piezo);
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
        $dumpvars(0,Write, clock, data, reset, Ack, Piezo);
    end

endmodule
