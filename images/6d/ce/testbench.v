`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock0;
    reg clock180;
    reg reset;
    reg [1:0] rotary;
    wire [7:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock0(clock0),
        .clock180(clock180),
        .reset(reset),
        .rotary(rotary),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clock0 = 0;
        forever #5 clock0 = ~clock0;
    end

        task reset_dut;

    begin
        reset = 1;
        rotary = 2'b00;
        @(posedge clock0);
        #2 reset = 0;
        @(posedge clock0);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Increment (00 -> 01)", test_num);
        reset_dut();
        rotary = 2'b01;
        @(posedge clock0);
        #2 rotary = 2'b00;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Increments (00 -> 0A)", test_num);
        reset_dut();
        rotary = 2'b01;
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clock0);
        end
        #2 rotary = 2'b00;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Wrap-around Decrement (00 -> FF)", test_num);
        reset_dut();
        rotary = 2'b10;
        @(posedge clock0);
        #2 rotary = 2'b00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Decrements (00 -> FB)", test_num);
        reset_dut();
        rotary = 2'b10;
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clock0);
        end
        #2 rotary = 2'b00;
        #1;

        check_outputs(8'hFB);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Increment Wrap-around (Full Cycle)", test_num);
        reset_dut();
        rotary = 2'b01;
        for (i = 0; i < 256; i = i + 1) begin
            @(posedge clock0);
        end
        #2 rotary = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Idle State 00", test_num);
        reset_dut();
        rotary = 2'b00;
        @(posedge clock0);
        @(posedge clock0);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Idle State 11", test_num);
        reset_dut();
        rotary = 2'b11;
        @(posedge clock0);
        @(posedge clock0);
        #1;

        check_outputs(8'h00);
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
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_leds;
        begin
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
        $dumpvars(0,clock0, clock180, reset, rotary, leds);
    end

endmodule
