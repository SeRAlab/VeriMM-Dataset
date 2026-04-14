`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] io_clears;
    reg [1:0] io_inputs;
    reg io_mainClk;
    reg [1:0] io_masks;
    reg resetCtrl_systemReset;
    wire [1:0] io_pendings;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_clears(io_clears),
        .io_inputs(io_inputs),
        .io_mainClk(io_mainClk),
        .io_masks(io_masks),
        .resetCtrl_systemReset(resetCtrl_systemReset),
        .io_pendings(io_pendings)
    );

    // Clock generation (10ns period)
    initial begin
        io_mainClk = 0;
        forever #5 io_mainClk = ~io_mainClk;
    end

        task reset_dut;

        begin
            resetCtrl_systemReset = 1;
            io_inputs = 2'b00;
            io_clears = 2'b00;
            io_masks = 2'b00;
            @(posedge io_mainClk);
            #1;
            resetCtrl_systemReset = 0;
            @(posedge io_mainClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            io_masks <= 2'b11;
            io_inputs <= 2'b11;
            repeat(2) @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            io_masks <= 2'b11;
            io_inputs <= 2'b11;
            @(posedge io_mainClk);

            io_inputs <= 2'b00;
            io_clears <= 2'b01;
            @(posedge io_mainClk);
            io_clears <= 2'b00;
            repeat(1) @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            io_inputs <= 2'b11;
            io_masks <= 2'b01;
            repeat(2) @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            io_masks <= 2'b11;

            io_inputs <= 2'b10;
            @(posedge io_mainClk);
            io_inputs <= 2'b00;
            repeat(2) @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            io_masks <= 2'b11;
            io_inputs <= 2'b11;
            @(posedge io_mainClk);

            resetCtrl_systemReset <= 1;
            @(posedge io_mainClk);
            #1;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_io_pendings;
        begin
            if (expected_io_pendings === (expected_io_pendings ^ io_pendings ^ expected_io_pendings)) begin
                $display("PASS");
                $display("  Outputs: io_pendings=%h",
                         io_pendings);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_pendings=%h",
                         expected_io_pendings);
                $display("  Got:      io_pendings=%h",
                         io_pendings);
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
        $dumpvars(0,io_clears, io_inputs, io_mainClk, io_masks, resetCtrl_systemReset, io_pendings);
    end

endmodule
