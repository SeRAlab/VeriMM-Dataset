`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] abc;
    reg clk;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .abc(abc),
        .clk(clk),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            abc = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd0;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd2;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd3;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd4;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd5;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd6;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            abc = 3'd7;
            @(posedge clk);
            #2;
            $display("Testcase %0d: abc = %b", test_num, abc);
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,abc, clk, y);
    end

endmodule
