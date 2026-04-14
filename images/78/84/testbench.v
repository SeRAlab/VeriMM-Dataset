`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_signal;
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_signal(in_signal),
        .edge_detected(edge_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_signal = 0;
            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_signal = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase %0d: Constant Low Input", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_signal = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Rising Edge Detection (0->1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_signal = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase %0d: Detection Pulse Duration (Should be 1 cycle)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in_signal = 1;
            repeat(2) @(posedge clk);
            in_signal = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Falling Edge (1->0) - No Detection", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            in_signal = 1;
            @(posedge clk);

            in_signal = 0;
            @(posedge clk);

            in_signal = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Second Rising Edge Detection", test_num);
            #1;

            check_outputs(1);
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
        input expected_edge_detected;
        begin
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%b",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%b",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%b",
                         edge_detected);
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
        $dumpvars(0,clk, in_signal, edge_detected);
    end

endmodule
