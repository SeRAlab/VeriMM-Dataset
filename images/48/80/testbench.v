`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg enable;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            enable = 0;
            #12;
            areset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial reset state", test_num);
            reset_dut();
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single step decrement", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Multiple steps (10)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(5'd21);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Decrement to zero", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Wrap around check (32 cycles)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk);
            end
            enable = 0;
            #1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable signal functionality", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd29);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Asynchronous reset mid-cycle", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #3;
            areset = 1;
            #1;
            #1;

            check_outputs(5'b11111);
            areset = 0;
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
        input [4:0] expected_count;
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
        $dumpvars(0,areset, clk, enable, count);
    end

endmodule
