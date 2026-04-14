`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] k0;
    reg [7:0] k1;
    reg [7:0] k2;
    reg [7:0] k3;
    reg reset;
    reg [7:0] x;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .k0(k0),
        .k1(k1),
        .k2(k2),
        .k3(k3),
        .reset(reset),
        .x(x),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 0;
            k0 = 0;
            k1 = 0;
            k2 = 0;
            k3 = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Response (k0)", test_num);
            reset_dut();
            k0 = 8'd5; k1 = 8'd0; k2 = 8'd0; k3 = 8'd0;
            x = 8'd10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Response (k3)", test_num);
            reset_dut();
            k0 = 8'd0; k1 = 8'd0; k2 = 8'd0; k3 = 8'd7;
            x = 8'd10;
            @(posedge clock); #1;
            x = 8'd0;
            @(posedge clock); #1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Step Response (Steady State)", test_num);
            reset_dut();
            k0 = 8'd2; k1 = 8'd3; k2 = 8'd4; k3 = 8'd5;
            x = 8'd10;

            repeat(5) begin
                @(posedge clock);
                #1;
            end

            #1;


            check_outputs(8'd140);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 8-bit Wrap-around", test_num);
            reset_dut();
            k0 = 8'd100; k1 = 8'd100; k2 = 8'd0; k3 = 8'd0;
            x = 8'd2;
            @(posedge clock); #1;
            @(posedge clock); #1;
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Coefficients", test_num);
            reset_dut();
            k0 = 8'd0; k1 = 8'd0; k2 = 8'd0; k3 = 8'd0;
            x = 8'd255;
            repeat(4) @(posedge clock);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-operation", test_num);
            reset_dut();
            k0 = 8'd10; x = 8'd10;
            @(posedge clock); #1;
            reset = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clock, k0, k1, k2, k3, reset, x, out);
    end

endmodule
