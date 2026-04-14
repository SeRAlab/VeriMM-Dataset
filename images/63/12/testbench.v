`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] address;
    reg clock;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 4096 (Threshold check, expect q=0)", test_num);
            reset_dut();
            address = 15'd4096;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 10000 (Expect q=0)", test_num);
            reset_dut();
            address = 15'd10000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 32767 (Max address, expect q=0)", test_num);
            reset_dut();
            address = 15'h7FFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from 0 to 5000", test_num);
            reset_dut();
            address = 15'd0;
            @(posedge clock);
            #1;

            address = 15'd5000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential check (address changes between clocks)", test_num);
            reset_dut();
            address = 15'd8000;
            @(posedge clock);
            #1;
            address = 15'd0;
            #2;
            if (q === 12'h000) begin
                $display("Subtest PASS: Output stayed 0 before next clock edge");
                #1;

                check_outputs(12'h000);
            end else begin
                $display("Subtest FAIL: Output changed asynchronously");
                fail_count = fail_count + 1;
            end
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,address, clock, q);
    end

endmodule
