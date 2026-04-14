`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg m;
    reg n;
    wire p;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m(m),
        .n(n),
        .p(p),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            m = 0;
            n = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            m = 0; n = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: m=0, n=0 (Set/Hold 1)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            m = 1; n = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: m=1, n=0 (Reset to 0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            m = 1; n = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: m=1, n=1 (Toggle 1->0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            m = 1; n = 0;
            @(posedge clk);
            #1;

            m = 1; n = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: m=1, n=1 (Toggle 0->1)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            m = 1; n = 0;
            @(posedge clk);
            #1;
            m = 1; n = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: m=1, n=0 (Hold 0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            m = 1; n = 0;
            @(posedge clk);
            #1;
            m = 0; n = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: m=0, n=1 (Set to 1)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_p;
        input expected_state;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: p=%b, state=%b",
                         p, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%b, state=%b",
                         expected_p, expected_state);
                $display("  Got:      p=%b, state=%b",
                         p, state);
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
        $dumpvars(0,clk, m, n, p, state);
    end

endmodule
