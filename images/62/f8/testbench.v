`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg en;
    reg [7:0] max;
    reg reset;
    reg up;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down(down),
        .en(en),
        .max(max),
        .reset(reset),
        .up(up),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up = 0;
            down = 0;
            en = 0;
            max = 8'hFF;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Increment", test_num);
            reset_dut();
            max = 8'd10;
            en = 1;
            up = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Basic Decrement", test_num);
            reset_dut();
            max = 8'd20;
            en = 1;
            up = 1;
            repeat (10) @(posedge clk);
            up = 0;
            down = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Max Limit Saturation", test_num);
            reset_dut();
            max = 8'd5;
            en = 1;
            up = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Min Limit Saturation", test_num);
            reset_dut();
            max = 8'd10;
            en = 1;
            down = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enable Signal Control", test_num);
            reset_dut();
            max = 8'd50;
            en = 1;
            up = 1;
            repeat (5) @(posedge clk);
            en = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Simultaneous Up and Down Priority", test_num);
            reset_dut();
            max = 8'd100;
            en = 1;
            up = 1;
            down = 1;
            repeat (4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Dynamic Max Limit Change", test_num);
            reset_dut();
            max = 8'd15;
            en = 1;
            up = 1;
            repeat (20) @(posedge clk);
            max = 8'd25;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd20);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, down, en, max, reset, up, q);
    end

endmodule
