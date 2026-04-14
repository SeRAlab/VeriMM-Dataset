`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg r;
    reg rst;
    reg s;
    wire srOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r(r),
        .rst(rst),
        .s(s),
        .srOut(srOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            s = 0;
            r = 0;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);

            rst = 0;
            @(negedge clk);
            s = 1;
            r = 0;
            @(posedge clk);
            #1;


            rst = 1;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Synchronous Set (S=1, R=0)", test_num);
            reset_dut();
            @(negedge clk);
            s = 1;
            r = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maintain State (Hold High)", test_num);
            reset_dut();

            @(negedge clk);
            s = 1; r = 0;
            @(posedge clk);

            @(negedge clk);
            s = 0; r = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Synchronous Reset (S=0, R=1)", test_num);
            reset_dut();

            @(negedge clk);
            s = 1; r = 0;
            @(posedge clk);

            @(negedge clk);
            s = 0; r = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maintain State (Hold Low)", test_num);
            reset_dut();

            @(negedge clk);
            s = 0; r = 1;
            @(posedge clk);

            @(negedge clk);
            s = 0; r = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Async Reset Priority Over S/R", test_num);
            reset_dut();
            @(negedge clk);
            s = 1;
            r = 0;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
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
        input expected_srOut;
        begin
            if (expected_srOut === (expected_srOut ^ srOut ^ expected_srOut)) begin
                $display("PASS");
                $display("  Outputs: srOut=%b",
                         srOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: srOut=%b",
                         expected_srOut);
                $display("  Got:      srOut=%b",
                         srOut);
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
        $dumpvars(0,clk, r, rst, s, srOut);
    end

endmodule
