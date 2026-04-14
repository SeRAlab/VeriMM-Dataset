`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down_count;
    reg reset;
    reg up_count;
    wire [2:0] num_entries;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down_count(down_count),
        .reset(reset),
        .up_count(up_count),
        .num_entries(num_entries)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_count = 0;
            down_count = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single increment (0 to 1)", test_num);
            reset_dut();
            up_count = 1;
            down_count = 0;
            @(posedge clk);
            #1;
            up_count = 0;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple increments (0 to 5)", test_num);
            reset_dut();
            up_count = 1;
            down_count = 0;
            repeat(5) @(posedge clk);
            #1;
            up_count = 0;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment then decrement (0 to 2 to 1)", test_num);
            reset_dut();
            up_count = 1;
            repeat(2) @(posedge clk);
            up_count = 0;
            down_count = 1;
            @(posedge clk);
            #1;
            down_count = 0;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Up and Down (No change)", test_num);
            reset_dut();

            up_count = 1;
            repeat(3) @(posedge clk);

            up_count = 1;
            down_count = 1;
            @(posedge clk);
            #1;
            up_count = 0;
            down_count = 0;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover/Overflow (7 to 0)", test_num);
            reset_dut();
            up_count = 1;
            repeat(8) @(posedge clk);
            #1;
            up_count = 0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover/Underflow (0 to 7)", test_num);
            reset_dut();
            down_count = 1;
            @(posedge clk);
            #1;
            down_count = 0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();
            up_count = 1;
            repeat(4) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_num_entries;
        begin
            if (expected_num_entries === (expected_num_entries ^ num_entries ^ expected_num_entries)) begin
                $display("PASS");
                $display("  Outputs: num_entries=%h",
                         num_entries);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num_entries=%h",
                         expected_num_entries);
                $display("  Got:      num_entries=%h",
                         num_entries);
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
        $dumpvars(0,clk, down_count, reset, up_count, num_entries);
    end

endmodule
