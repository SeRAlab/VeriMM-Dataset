`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] datain;
    reg rst;
    wire done;
    wire [511:0] hashout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .rst(rst),
        .done(done),
        .hashout(hashout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            datain = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SHA-1 for 'abc'", test_num);
            reset_dut();
            datain = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;


            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 512'ha9993e364706816aba3e25717850c26c9cd0d89d);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SHA-1 for empty string", test_num);
            reset_dut();
            datain = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 512'hda39a3ee5e6b4b0d3255bfef95601890afd80709);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SHA-1 for 32-byte string", test_num);
            reset_dut();
            datain = 512'h6162636462636465636465666465666765666768666768696768696a68696a6b80000000000000000000000000000000000000000000000000000000000000000000000000000100;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 512'h425af38060db94818ca96ceee7454ba903f79245);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            datain = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;


            repeat(40) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            datain = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 512'ha9993e364706816aba3e25717850c26c9cd0d89d);
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
        input expected_done;
        input [511:0] expected_hashout;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hashout === (expected_hashout ^ hashout ^ expected_hashout)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hashout=%h",
                         done, hashout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hashout=%h",
                         expected_done, expected_hashout);
                $display("  Got:      done=%b, hashout=%h",
                         done, hashout);
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
        $dumpvars(0,clk, datain, rst, done, hashout);
    end

endmodule
