`timescale 1ns/1ps

module counter_with_preset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg preset;
    reg [5:0] preset_value;
    reg reset;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_preset dut (
        .clk(clk),
        .preset(preset),
        .preset_value(preset_value),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            preset = 0;
            preset_value = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset");
            reset_dut();
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Counting (10 cycles)");
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Asynchronous Preset");
            reset_dut();
            preset_value = 6'd42;
            #2;
            preset = 1;
            #10;
            preset = 0;
            #2;
            #1;

            check_outputs(6'd42);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Counting after Preset");
            reset_dut();
            preset_value = 6'd20;
            preset = 1;
            #10;
            preset = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd25);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Counter Rollover (63 to 0)");
            reset_dut();
            preset_value = 6'd63;
            preset = 1;
            #10;
            preset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Asynchronous Reset during counting");
            reset_dut();
            repeat(5) @(posedge clk);
            reset = 1;
            #5;
            reset = 0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Mid-cycle Asynchronous Preset");
            reset_dut();
            @(posedge clk);
            #3;
            preset_value = 6'd15;
            preset = 1;
            #2;
            preset = 0;
            #1;

            check_outputs(6'd15);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Multi-rollover after high preset");
            reset_dut();
            preset_value = 6'd60;
            preset = 1;
            #10;
            preset = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_preset Testbench");
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, preset, preset_value, reset, count);
    end

endmodule
