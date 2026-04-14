`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg preset;
    reg [15:0] preset_value;
    reg rst;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .clk(clk),
        .en(en),
        .preset(preset),
        .preset_value(preset_value),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            preset = 0;
            preset_value = 0;
            #15;
            rst = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            en = 1;
            repeat(5) @(posedge clk);
            #2 rst = 0;
            #5;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Counting (10 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Preset Capability", test_num);
            reset_dut();
            preset_value = 16'hA5A5;
            preset = 1;
            @(posedge clk);
            #1;
            preset = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Enable Control (Stop counting)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Preset to Max and Overflow", test_num);
            reset_dut();

            preset_value = 16'hFFFF;
            preset = 1;
            @(posedge clk);
            #1;
            preset = 0;
            en = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Preset Priority Over Enable", test_num);
            reset_dut();
            en = 1;
            preset_value = 16'h1234;
            preset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        $dumpvars(0,clk, en, preset, preset_value, rst, count);
    end

endmodule
