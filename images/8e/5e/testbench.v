`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] KEY;
    reg [2:0] SW;
    wire [2:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR)
    );

        task reset_dut;

        begin
            KEY[0] = 0;
            KEY[1] = 1;
            SW = 3'b000;
            tick();
            KEY[1] = 0;
        end
        endtask
    task tick;

        begin
            #10 KEY[0] = 1;
            #10 KEY[0] = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Load 3'b101", test_num);
            reset_dut();
            KEY[1] = 1;
            SW = 3'b101;
            tick();
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load All Ones", test_num);
            reset_dut();
            KEY[1] = 1;
            SW = 3'b111;
            tick();
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Shift Transition from 101", test_num);
            reset_dut();

            KEY[1] = 1;
            SW = 3'b101;
            tick();

            KEY[1] = 0;
            tick();
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Shift Transition from 111", test_num);
            reset_dut();
            KEY[1] = 1;
            SW = 3'b111;
            tick();
            KEY[1] = 0;
            tick();
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-cycle Shift from 100", test_num);
            reset_dut();
            KEY[1] = 1;
            SW = 3'b100;
            tick();
            KEY[1] = 0;
            tick();
            tick();
            #1;

            check_outputs(3'b111);
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
        input [2:0] expected_LEDR;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
        $dumpvars(0,KEY, SW, LEDR);
    end

endmodule
