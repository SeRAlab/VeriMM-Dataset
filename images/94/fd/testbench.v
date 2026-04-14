`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up_down;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .up_down(up_down),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            up_down = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing synchronous reset to 0000", test_num);
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing up counting for 5 cycles", test_num);
            reset_dut();
            up_down = 0;
            repeat(5) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing up counter rollover (15 to 0)", test_num);
            reset_dut();
            up_down = 0;
            repeat(16) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing down counting from 0 (rollover to 15)", test_num);
            reset_dut();
            up_down = 1;
            repeat(1) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing down counting for 10 cycles", test_num);
            reset_dut();
            up_down = 1;
            repeat(10) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing switching direction mid-count", test_num);
            reset_dut();
            up_down = 0;
            repeat(8) @(posedge clk);
            up_down = 1;
            repeat(3) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Testing full range down counter rollover", test_num);
            reset_dut();
            up_down = 1;
            repeat(17) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Testing synchronous reset during active counting", test_num);
            reset_dut();
            up_down = 0;
            repeat(4) @(posedge clk);
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            @(negedge clk);
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, up_down, q);
    end

endmodule
