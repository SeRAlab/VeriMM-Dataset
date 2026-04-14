`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] address;
    reg clock;
    reg [11:0] q;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q),
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
            q = 0;

            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write/Read at Address 0x0000", test_num);
            reset_dut();

            address = 15'h0000;
            q = 12'hAAA;

            @(negedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'hAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write/Read at Max Address 0x7FFF", test_num);
            reset_dut();

            address = 15'h7FFF;
            q = 12'h555;

            @(negedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'h555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write pattern 0xF0F to Address 0x4321", test_num);
            reset_dut();

            address = 15'h4321;
            q = 12'hF0F;

            @(negedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'hF0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Address 0x4321", test_num);
            reset_dut();


            address = 15'h4321;
            q = 12'hF0F;
            @(negedge clock);


            q = 12'h0F0;
            @(negedge clock);

            @(posedge clock);
            #1;

            #1;


            check_outputs(12'h0F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verification of Independent Addresses", test_num);
            reset_dut();


            address = 15'h0100;
            q = 12'hCDE;
            @(negedge clock);


            address = 15'h0200;
            q = 12'h888;
            @(negedge clock);


            address = 15'h0100;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'hCDE);
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
        input [11:0] expected_out;
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
        $dumpvars(0,address, clock, q, out);
    end

endmodule
