`timescale 1ns/1ps

module binary_counter_16bit_sync_clear_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_16bit_sync_clear dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        clear = 1;
        enable = 0;
        @(negedge clk);
        clear = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Power-on Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Simple Increment to 10", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(10) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(16'h000A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Enable Gating (Disable check)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(5) @(negedge clk);
        enable = 0;
        repeat(5) @(negedge clk);
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Synchronous Clear Priority", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(20) @(negedge clk);
        clear = 1;
        @(negedge clk);
        clear = 0;
        enable = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Large Value Increment", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        repeat(512) @(negedge clk);
        enable = 0;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Intermittent Enable", test_num);
        reset_dut();
        @(negedge clk);
        repeat(10) begin
            enable = 1; @(negedge clk);
            enable = 0; @(negedge clk);
        end
        #1;

        check_outputs(16'h000A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_16bit_sync_clear Testbench");
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
        input [15:0] expected_count;
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
        $dumpvars(0,clear, clk, enable, count);
    end

endmodule
