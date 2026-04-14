`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg d_in;
    reg rst_n;
    wire found;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .d_in(d_in),
        .rst_n(rst_n),
        .found(found)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst_n = 0;
            d_in = 0;
            repeat(2) @(posedge clock);
            #1 rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic detection '1101'", test_num);
            reset_dut();
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: False sequence '1100'", test_num);
            reset_dut();
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Extra ones '11101'", test_num);
            reset_dut();
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Overlapping sequences '1101101'", test_num);
            reset_dut();
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All zeros stream", test_num);
            reset_dut();
            repeat(5) @(posedge clock) d_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All ones stream", test_num);
            reset_dut();
            repeat(5) @(posedge clock) d_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Interrupted sequence with reset", test_num);
            reset_dut();
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;

            #2 rst_n = 0;
            repeat(2) @(posedge clock);
            #1 rst_n = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Sequence followed by zero", test_num);
            reset_dut();
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock) d_in = 1;
            @(posedge clock) d_in = 0;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_found;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found)) begin
                $display("PASS");
                $display("  Outputs: found=%b",
                         found);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b",
                         expected_found);
                $display("  Got:      found=%b",
                         found);
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
        $dumpvars(0,clock, d_in, rst_n, found);
    end

endmodule
