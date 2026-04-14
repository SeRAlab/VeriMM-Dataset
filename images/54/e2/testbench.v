`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg inter_clk;
    wire [2:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inter_clk(inter_clk),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        inter_clk = 0;
        forever #5 inter_clk = ~inter_clk;
    end

        task reset_dut;

        begin



            force dut.c = 3'b000;
            @(negedge inter_clk);
            release dut.c;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment by 1", test_num);
            reset_dut();
            @(posedge inter_clk);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to middle value (4)", test_num);
            reset_dut();
            repeat(4) @(posedge inter_clk);
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to maximum value (7)", test_num);
            reset_dut();
            repeat(7) @(posedge inter_clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Test wrap-around (8 cycles)", test_num);
            reset_dut();
            repeat(8) @(posedge inter_clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Test wrap-around and continue (10 cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge inter_clk);
            #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large number of cycles (20 cycles)", test_num);
            reset_dut();
            repeat(20) @(posedge inter_clk);
            #1;

            #1;


            check_outputs(3'd4);
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
        input [2:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,inter_clk, c);
    end

endmodule
