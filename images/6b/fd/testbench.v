`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] address;
    reg clock;
    reg [15:0] in;
    reg load;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .in(in),
        .load(load),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 0;
            in = 0;
            load = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            address = 13'h0000;
            in = 16'hABCD;
            load = 1;
            @(posedge clock);
            #1;

            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            address = 13'h1FFF;
            in = 16'h55AA;
            load = 1;
            @(posedge clock);
            #1;
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            address = 13'h0123;
            in = 16'h1111;
            load = 1;
            @(posedge clock);
            #1;

            in = 16'hEEEE;
            load = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            address = 13'h0ABC;
            in = 16'h1234;
            load = 1;
            @(posedge clock);
            #1;
            in = 16'h5678;
            load = 1;
            @(posedge clock);
            #1;
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            address = 13'h0010;
            in = 16'hAAAA;
            load = 1;
            @(posedge clock);
            #1;

            address = 13'h0020;
            in = 16'hBBBB;
            load = 1;
            @(posedge clock);
            #1;

            address = 13'h0010;
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_out;
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
        $dumpvars(0,address, clock, in, load, out);
    end

endmodule
