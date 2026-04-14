`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg data;
    reg enable;
    reg reset;
    wire q;
    wire qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .enable(enable),
        .reset(reset),
        .q(q),
        .qbar(qbar)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 0;
            data = 0;
            enable = 0;
            #15;
            reset = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Async reset active", test_num);

            enable = 1;
            data = 1;
            #2;
            reset = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Synchronous load '1'", test_num);
            @(negedge clock);
            enable = 1;
            data = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clock);
            enable = 1;
            data = 1;
            @(posedge clock);
            #2;

            @(negedge clock);
            data = 0;
            @(posedge clock);
            #2;
            $display("Testcase %0d: Synchronous load '0'", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clock);
            enable = 1;
            data = 1;
            @(posedge clock);
            #2;

            @(negedge clock);
            enable = 0;
            data = 0;
            @(posedge clock);
            #2;
            $display("Testcase %0d: Data change ignored when enable is low", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clock);
            enable = 1;
            data = 1;
            @(posedge clock);
            #2;

            #3;
            reset = 0;
            #1;
            $display("Testcase %0d: Async reset mid-clock-cycle", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Data change without clock edge", test_num);
            @(negedge clock);
            enable = 1;
            data = 1;
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_q;
        input expected_qbar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qbar === (expected_qbar ^ qbar ^ expected_qbar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qbar=%b",
                         q, qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qbar=%b",
                         expected_q, expected_qbar);
                $display("  Got:      q=%b, qbar=%b",
                         q, qbar);
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
        $dumpvars(0,clock, data, enable, reset, q, qbar);
    end

endmodule
