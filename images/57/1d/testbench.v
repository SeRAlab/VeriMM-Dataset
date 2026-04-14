`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [4:0] data;
    reg load;
    reg si;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .load(load),
        .si(si),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            load = 1;
            data = 5'b00000;
            si = 0;
            @(negedge clock);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clock);
            load = 1;
            data = 5'b10110;
            @(negedge clock);
            load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clock);
            load = 1;
            data = 5'b01111;
            @(negedge clock);
            load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clock);
            load = 1;
            data = 5'b01000;
            @(negedge clock);
            load = 0;
            si = 0;
            @(negedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clock);
            si = 1; load = 0; @(negedge clock);
            si = 0; @(negedge clock);
            si = 0; @(negedge clock);
            si = 0; @(negedge clock);
            si = 0; @(negedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clock);
            load = 1;
            data = 5'b11111;
            @(negedge clock);
            load = 0;
            si = 0;

            repeat(5) @(negedge clock);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clock);
            si = 1; load = 0; @(negedge clock);
            si = 0; @(negedge clock);
            si = 1; @(negedge clock);
            si = 0; @(negedge clock);
            si = 1; @(negedge clock);
            #1;

            check_outputs(1'b1);
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
        input expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%b",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%b",
                         expected_so);
                $display("  Got:      so=%b",
                         so);
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
        $dumpvars(0,clock, data, load, si, so);
    end

endmodule
