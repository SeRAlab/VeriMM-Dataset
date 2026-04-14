`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] counter;
    wire interrupt_event;
    wire [7:0] waveforms;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .counter(counter),
        .interrupt_event(interrupt_event),
        .waveforms(waveforms)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %03d: Transition State 0 to State 1", test_num);
            reset_dut();

            repeat(127) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd127, 1'b0, 8'h00);


            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd128, 1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: State 1 Waveform Logic (Counter 130)", test_num);
            reset_dut();
            repeat(130) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd130, 1'b0, 8'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Transition State 1 to State 2", test_num);
            reset_dut();
            repeat(191) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd191, 1'b0, 8'hE0);


            @(posedge clk);
            #1;

            if (counter === 8'd192 && interrupt_event === 1'b0) begin
                $display("PASS: Reached State 2 at counter 192");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected counter 192, got %d", counter);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Interrupt Event at Counter 255", test_num);
            reset_dut();
            repeat(255) @(posedge clk);
            #1;

            if (counter === 8'd255 && interrupt_event === 1'b1) begin
                $display("PASS: Interrupt event set at 255");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected counter 255 and interrupt_event=1. Got counter=%d, int=%b", counter, interrupt_event);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Counter Wrap Around Logic", test_num);
            reset_dut();
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b0, 8'h00);
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
        testcase006();
        
        
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
        input [7:0] expected_counter;
        input expected_interrupt_event;
        input [7:0] expected_waveforms;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_interrupt_event === (expected_interrupt_event ^ interrupt_event ^ expected_interrupt_event) &&
                expected_waveforms === (expected_waveforms ^ waveforms ^ expected_waveforms)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, interrupt_event=%b, waveforms=%h",
                         counter, interrupt_event, waveforms);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, interrupt_event=%b, waveforms=%h",
                         expected_counter, expected_interrupt_event, expected_waveforms);
                $display("  Got:      counter=%h, interrupt_event=%b, waveforms=%h",
                         counter, interrupt_event, waveforms);
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
        $dumpvars(0,clk, reset, counter, interrupt_event, waveforms);
    end

endmodule
