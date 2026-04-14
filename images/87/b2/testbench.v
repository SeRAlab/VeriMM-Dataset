`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg resetn;
    reg [63:0] vector1;
    reg [63:0] vector2;
    wire [63:0] result_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .resetn(resetn),
        .vector1(vector1),
        .vector2(vector2),
        .result_vector(result_vector)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            vector1 = 0;
            vector2 = 0;
            @(posedge clock);
            #1;
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Basic Addition", test_num);
            reset_dut();
            vector1 = 64'h0000_0000_0000_0005;
            vector2 = 64'h0000_0000_0000_000A;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Zero Addition", test_num);
            reset_dut();
            vector1 = 64'hFFFF_FFFF_FFFF_FFFF;
            vector2 = 64'h0000_0000_0000_0000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Overflow Wrap-around", test_num);
            reset_dut();
            vector1 = 64'hFFFF_FFFF_FFFF_FFFF;
            vector2 = 64'h0000_0000_0000_0001;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Bit Pattern Addition", test_num);
            reset_dut();
            vector1 = 64'h5555_5555_5555_5555;
            vector2 = 64'hAAAA_AAAA_AAAA_AAAA;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Reset Priority Check", test_num);
            reset_dut();
            vector1 = 64'h1234_5678_9ABC_DEF0;
            vector2 = 64'h0000_0000_0000_0001;

            resetn = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: 64-bit Carry Propagation", test_num);
            reset_dut();
            vector1 = 64'h7FFF_FFFF_FFFF_FFFF;
            vector2 = 64'h0000_0000_0000_0001;
            @(posedge clock);
            #2;
            #1;

            check_outputs(64'h8000_0000_0000_0000);
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
        input [63:0] expected_result_vector;
        begin
            if (expected_result_vector === (expected_result_vector ^ result_vector ^ expected_result_vector)) begin
                $display("PASS");
                $display("  Outputs: result_vector=%h",
                         result_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_vector=%h",
                         expected_result_vector);
                $display("  Got:      result_vector=%h",
                         result_vector);
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
        $dumpvars(0,clock, resetn, vector1, vector2, result_vector);
    end

endmodule
