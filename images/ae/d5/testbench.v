`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg r;
    reg [6:0] speed;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .r(r),
        .speed(speed),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            r = 1;
            enable = 0;
            speed = 0;
            @(posedge clk);
            #1;
            r = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Reset Logic", test_num);
            reset_dut();

            #1;


            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Tracking Incremental Maximums", test_num);
            reset_dut();
            enable = 1;
            speed = 7'd10; @(posedge clk);
            speed = 7'd45; @(posedge clk);
            speed = 7'd82; @(posedge clk);
            #1;
            #1;

            check_outputs(7'd82);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Ignoring Speed Values Lower Than Current Max", test_num);
            reset_dut();
            enable = 1;
            speed = 7'd100; @(posedge clk);
            speed = 7'd50;  @(posedge clk);
            speed = 7'd99;  @(posedge clk);
            #1;
            #1;

            check_outputs(7'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verification of Enable Signal (Inhibit Update)", test_num);
            reset_dut();
            enable = 1;
            speed = 7'd20; @(posedge clk);
            enable = 0;
            speed = 7'd120; @(posedge clk);
            speed = 7'd50;  @(posedge clk);
            #1;
            #1;

            check_outputs(7'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum 7-bit Value (127)", test_num);
            reset_dut();
            enable = 1;
            speed = 7'h7F; @(posedge clk);
            speed = 7'h00; @(posedge clk);
            #1;
            #1;

            check_outputs(7'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Mid-operation Reset", test_num);
            reset_dut();
            enable = 1;
            speed = 7'd60; @(posedge clk);
            r = 1;         @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Intermittent Enable Toggling", test_num);
            reset_dut();
            enable = 1; speed = 7'd10; @(posedge clk);
            enable = 0; speed = 7'd20; @(posedge clk);
            enable = 1; speed = 7'd15; @(posedge clk);
            enable = 1; speed = 7'd30; @(posedge clk);
            #1;
            #1;

            check_outputs(7'd30);
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
        input [6:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, enable, r, speed, out);
    end

endmodule
