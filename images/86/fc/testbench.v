`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] id_control_signals;
    reg reset;
    wire [3:0] ex_control_signals;
    wire [3:0] mem_control_signals;
    wire [3:0] wb_control_signals;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .id_control_signals(id_control_signals),
        .reset(reset),
        .ex_control_signals(ex_control_signals),
        .mem_control_signals(mem_control_signals),
        .wb_control_signals(wb_control_signals)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            id_control_signals = 4'b0;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Propagation", test_num);
            reset_dut();

            id_control_signals = 4'hA;
            @(posedge clock);
            #1;

            id_control_signals = 4'hB;
            @(posedge clock);
            #1;

            id_control_signals = 4'hC;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'hC, 4'hB, 4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Override", test_num);
            reset_dut();

            id_control_signals = 4'hF;
            @(posedge clock);
            id_control_signals = 4'hE;
            @(posedge clock);


            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Steady State Propagation", test_num);
            reset_dut();

            id_control_signals = 4'h7;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'h7, 4'h7, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();

            id_control_signals = 4'b1010; @(posedge clock);
            id_control_signals = 4'b0101; @(posedge clock);
            id_control_signals = 4'b1010; @(posedge clock);
            id_control_signals = 4'b1111; @(posedge clock);
            #1;





            #1;






            check_outputs(4'b1111, 4'b1010, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Signal Propagation", test_num);
            reset_dut();

            id_control_signals = 4'hF; @(posedge clock);
            id_control_signals = 4'h0; @(posedge clock);
            id_control_signals = 4'hF; @(posedge clock);
            #1;

            #1;


            check_outputs(4'hF, 4'h0, 4'hF);
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
        input [3:0] expected_ex_control_signals;
        input [3:0] expected_mem_control_signals;
        input [3:0] expected_wb_control_signals;
        begin
            if (expected_ex_control_signals === (expected_ex_control_signals ^ ex_control_signals ^ expected_ex_control_signals) &&
                expected_mem_control_signals === (expected_mem_control_signals ^ mem_control_signals ^ expected_mem_control_signals) &&
                expected_wb_control_signals === (expected_wb_control_signals ^ wb_control_signals ^ expected_wb_control_signals)) begin
                $display("PASS");
                $display("  Outputs: ex_control_signals=%h, mem_control_signals=%h, wb_control_signals=%h",
                         ex_control_signals, mem_control_signals, wb_control_signals);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ex_control_signals=%h, mem_control_signals=%h, wb_control_signals=%h",
                         expected_ex_control_signals, expected_mem_control_signals, expected_wb_control_signals);
                $display("  Got:      ex_control_signals=%h, mem_control_signals=%h, wb_control_signals=%h",
                         ex_control_signals, mem_control_signals, wb_control_signals);
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
        $dumpvars(0,clock, id_control_signals, reset, ex_control_signals, mem_control_signals, wb_control_signals);
    end

endmodule
