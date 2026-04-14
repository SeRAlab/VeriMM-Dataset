`timescale 1ns/1ps

module sync_up_counter_with_preset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg preset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_counter_with_preset dut (
        .clk(clk),
        .enable(enable),
        .preset(preset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        preset = 1;
        #10;
        preset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Asynchronous Preset check", test_num);
        reset_dut();

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Counter stays same when enable=0", test_num);
        reset_dut();
        @(posedge clk);
        enable = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment by 1 when enable=1", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        @(posedge clk);
        enable = 0;
        #1;
        #1;

        check_outputs(8'hAB);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment by 10 cycles", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        repeat(10) @(posedge clk);
        enable = 0;
        #1;
        #1;

        check_outputs(8'hAA + 8'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Asynchronous Preset override during counting", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        repeat(3) @(posedge clk);


        #3;
        preset = 1;
        #2;
        #1;

        check_outputs(8'hAA);
        preset = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable toggling behavior", test_num);
        reset_dut();
        @(posedge clk);
        enable = 1;
        @(posedge clk);
        enable = 0;
        @(posedge clk);
        enable = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_counter_with_preset Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, enable, preset, q);
    end

endmodule
