`timescale 1ns/1ps

module sync_up_counter_saturate_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg sync_reset;
    wire [15:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_counter_saturate dut (
        .clk(clk),
        .enable(enable),
        .sync_reset(sync_reset),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sync_reset = 1;
        enable = 0;
        @(posedge clk);
        #1;
        sync_reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Incrementing (10 cycles)", test_num);
        reset_dut();
        enable = 1;
        repeat (10) @(posedge clk);
        #1;
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Control", test_num);
        reset_dut();
        enable = 1;
        repeat (5) @(posedge clk);
        enable = 0;
        repeat (5) @(posedge clk);
        #1;

        #1;


        check_outputs(16'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Reset during counting", test_num);
        reset_dut();
        enable = 1;
        repeat (20) @(posedge clk);
        sync_reset = 1;
        @(posedge clk);
        #1;
        sync_reset = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Saturation at Max Value (16'hFFFF)", test_num);
        reset_dut();
        enable = 1;


        repeat (65535) @(posedge clk);
        #1;
        $display("  Reached 65535...");
        #1;

        check_outputs(16'hFFFF);


        repeat (10) @(posedge clk);
        #1;
        $display("  Checking saturation after 10 more cycles...");
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset after saturation", test_num);
        reset_dut();
        enable = 1;
        repeat (65535) @(posedge clk);
        #1;
        sync_reset = 1;
        @(posedge clk);
        #1;
        sync_reset = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_counter_saturate Testbench");
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
        input [15:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk, enable, sync_reset, count_out);
    end

endmodule
