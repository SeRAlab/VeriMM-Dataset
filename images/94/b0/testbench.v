`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg key;
    reg nrq1;
    reg nrq2;
    reg nrq3;
    wire [1:0] mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key(key),
        .nrq1(nrq1),
        .nrq2(nrq2),
        .nrq3(nrq3),
        .mux(mux)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            key = 0;
            nrq1 = 0;
            nrq2 = 0;
            nrq3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            key = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            key = 1;
            @(posedge clk);
            #1;
            nrq1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            key = 1;
            @(posedge clk);
            #1; nrq1 = 1;
            @(posedge clk);
            #1; nrq1 = 0; nrq2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            key = 1;
            @(posedge clk);
            #1; nrq1 = 1;
            @(posedge clk);
            #1; nrq1 = 0; nrq2 = 1;
            @(posedge clk);
            #1; nrq2 = 0; nrq3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            key = 1;
            @(posedge clk);
            #1; nrq1 = 1;
            @(posedge clk);
            #1;
            key = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            key = 1;
            @(posedge clk);
            #1;
            nrq1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            key = 0;
            nrq1 = 1; nrq2 = 1; nrq3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_mux;
        begin
            if (expected_mux === (expected_mux ^ mux ^ expected_mux)) begin
                $display("PASS");
                $display("  Outputs: mux=%h",
                         mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux=%h",
                         expected_mux);
                $display("  Got:      mux=%h",
                         mux);
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
        $dumpvars(0,clk, key, nrq1, nrq2, nrq3, mux);
    end

endmodule
