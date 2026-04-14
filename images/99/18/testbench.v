`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [63:0] dataa;
    reg [63:0] datab;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            dataa = 64'd0;
            datab = 64'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            dataa = 64'h3FF0000000000000;
            datab = 64'h3FF0000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h3FF0000000000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            dataa = 64'h4000000000000000;
            datab = 64'h4008000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h4018000000000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            dataa = 64'h3FF8000000000000;
            datab = 64'hC010000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'hC018000000000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            dataa = 64'h4014000000000000;
            datab = 64'h0000000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            dataa = 64'h7FF0000000000000;
            datab = 64'h3FF0000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h7FF0000000000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            dataa = 64'h3FE0000000000000;
            datab = 64'h3FE0000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h3FD0000000000000);
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
        input [63:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clock, dataa, datab, result);
    end

endmodule
