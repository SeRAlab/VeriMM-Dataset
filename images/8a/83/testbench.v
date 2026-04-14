`timescale 1ns/1ps

module down_counter_10_with_preset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg preset;
    reg [9:0] preset_value;
    reg rst;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter_10_with_preset dut (
        .clk(clk),
        .enable(enable),
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
            @(negedge clk);
            rst = 1;
            enable = 0;
            preset = 0;
            preset_value = 10'b0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Preset Value", test_num);
            reset_dut();
            @(negedge clk);
            preset = 1;
            preset_value = 10'h1AB;
            @(negedge clk);
            preset = 0;
            #1;

            check_outputs(10'h1AB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple Decrement (5 steps)", test_num);
            reset_dut();

            @(negedge clk);
            preset = 1;
            preset_value = 10'd10;
            @(negedge clk);
            preset = 0;

            enable = 1;
            repeat (5) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(10'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable/Disable Toggle", test_num);
            reset_dut();

            @(negedge clk);
            preset = 1;
            preset_value = 10'd20;
            @(negedge clk);
            preset = 0;

            enable = 1;
            repeat (2) @(negedge clk);

            enable = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(10'd18);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Underflow Wraparound", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority (Preset over Enable)", test_num);
            reset_dut();
            @(negedge clk);
            preset = 1;
            preset_value = 10'h2FF;
            enable = 1;
            @(negedge clk);
            preset = 0;
            enable = 0;
            #1;

            check_outputs(10'h2FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Large Value and Multiple Steps", test_num);
            reset_dut();
            @(negedge clk);
            preset = 1;
            preset_value = 10'd1000;
            @(negedge clk);
            preset = 0;
            enable = 1;
            repeat (100) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(10'd900);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter_10_with_preset Testbench");
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
        input [9:0] expected_count;
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
        $dumpvars(0,clk, enable, preset, preset_value, rst, count);
    end

endmodule
