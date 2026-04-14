`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg up_down;
    wire [7:0] qd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .up_down(up_down),
        .qd(qd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            up_down = 1;
            @(posedge clk);
            #1 clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset/Clear", test_num);
            reset_dut();

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Up-count to 10", test_num);
            reset_dut();
            up_down = 1;

            repeat (10) @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Up-count Rollover (10 -> 0)", test_num);
            reset_dut();
            up_down = 1;

            repeat (11) @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Down-count Wrap (0 -> 10)", test_num);
            reset_dut();
            up_down = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Down-count multiple steps (0 -> 10 -> 9 -> 8)", test_num);
            reset_dut();
            up_down = 0;
            repeat (3) @(posedge clk);
            #1 #1;
 check_outputs(8'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Clear", test_num);
            reset_dut();
            up_down = 1;
            repeat (5) @(posedge clk);
            clear = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Direction switching (Up to 5, then Down to 3)", test_num);
            reset_dut();
            up_down = 1;
            repeat (5) @(posedge clk);
            up_down = 0;
            repeat (2) @(posedge clk);
            #1 #1;
 check_outputs(8'd3);
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
        input [7:0] expected_qd;
        begin
            if (expected_qd === (expected_qd ^ qd ^ expected_qd)) begin
                $display("PASS");
                $display("  Outputs: qd=%h",
                         qd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qd=%h",
                         expected_qd);
                $display("  Got:      qd=%h",
                         qd);
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
        $dumpvars(0,clear, clk, up_down, qd);
    end

endmodule
