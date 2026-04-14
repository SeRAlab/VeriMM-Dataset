`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire [3:0] edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .edge(edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 4'b0000;

            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in = 4'b0001;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: Positive edge bit 0", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in = 4'b1000;
            @(posedge clk);
            in = 4'b0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: Negative edge bit 3", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in = 4'b1010;
            @(posedge clk);
            in = 4'b0101;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: Mixed edges on all bits", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in = 4'b0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: No change (0 to 0)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in = 4'b1111;
            @(posedge clk);
            @(posedge clk);
            in = 4'b1111;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: No change (1 to 1)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in = 4'b1111;
            @(posedge clk);
            in = 4'b0000;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: All bits negative edge", test_num);
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_edge;
        begin
            if (expected_edge === (expected_edge ^ edge ^ expected_edge)) begin
                $display("PASS");
                $display("  Outputs: edge=%h",
                         edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge=%h",
                         expected_edge);
                $display("  Got:      edge=%h",
                         edge);
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
        $dumpvars(0,clk, in, edge);
    end

endmodule
