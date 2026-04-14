`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg feedback_clk;
    reg in_data;
    reg ref_clk;
    wire out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .feedback_clk(feedback_clk),
        .in_data(in_data),
        .ref_clk(ref_clk),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        feedback_clk = 0;
        forever #5 feedback_clk = ~feedback_clk;
    end

        task reset_dut;

        begin
            in_data = 0;

            repeat (32) @(posedge feedback_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Single high pulse propagation");
            reset_dut();
            in_data = 1;
            @(posedge feedback_clk);
            #1 in_data = 0;


            repeat (4) @(posedge feedback_clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Persistent high signal");
            reset_dut();
            in_data = 1;
            repeat (10) @(posedge feedback_clk);
            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Logic low transition");
            reset_dut();
            in_data = 1;
            repeat (10) @(posedge feedback_clk);
            #1 in_data = 0;

            repeat (5) @(posedge feedback_clk);
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Pattern 1010 propagation");
            reset_dut();
            in_data = 1; @(posedge feedback_clk);
            #1 in_data = 0; @(posedge feedback_clk);
            #1 in_data = 1; @(posedge feedback_clk);
            #1 in_data = 0; @(posedge feedback_clk);

            repeat (4) @(posedge feedback_clk);
            #2 #1;
 check_outputs(1'b0);
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
        input expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%b",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%b",
                         expected_out_data);
                $display("  Got:      out_data=%b",
                         out_data);
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
        $dumpvars(0,feedback_clk, in_data, ref_clk, out_data);
    end

endmodule
