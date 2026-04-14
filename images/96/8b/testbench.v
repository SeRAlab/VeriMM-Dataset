`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clk;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clk(clk),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            button = 0;


            for (i = 0; i < 8; i = i + 1) begin
                if (count !== 3'b000) begin
                    @(negedge clk);
                    button = 1;
                    @(negedge clk);
                    button = 0;
                end
            end
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing single button press...", test_num);
            reset_dut();
            @(negedge clk);
            button = 1;
            @(negedge clk);
            button = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing two button presses...", test_num);
            reset_dut();
            repeat(2) begin
                @(negedge clk);
                button = 1;
                @(negedge clk);
                button = 0;
            end
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 4 presses (State cycle rollover)...", test_num);
            reset_dut();
            repeat(4) begin
                @(negedge clk);
                button = 1;
                @(negedge clk);
                button = 0;
            end
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 8 presses (3-bit counter rollover)...", test_num);
            reset_dut();
            repeat(8) begin
                @(negedge clk);
                button = 1;
                @(negedge clk);
                button = 0;
            end
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing 7 presses (Max count)...", test_num);
            reset_dut();
            repeat(7) begin
                @(negedge clk);
                button = 1;
                @(negedge clk);
                button = 0;
            end
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'd7);
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
        input [2:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,button, clk, count);
    end

endmodule
