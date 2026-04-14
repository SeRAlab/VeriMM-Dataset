`timescale 1ns/1ps

module binary_counter_load_7_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [6:0] load_value;
    reg rst;
    wire [6:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_load_7 dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_value(load_value),
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
            rst = 1;
            enable = 0;
            load = 0;
            load_value = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset Verification");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple Increment");
            reset_dut();
            enable = 1;
            load = 0;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load Functionality");
            reset_dut();
            load = 1;
            load_value = 7'h42;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h42);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable/Disable Toggle");
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load Priority over Enable");
            reset_dut();
            load = 1;
            load_value = 7'h1F;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h1F);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Counter Wrap-around");
            reset_dut();
            load = 1;
            load_value = 7'h7F;
            @(posedge clk);
            load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Increment from Loaded Value");
            reset_dut();
            load = 1;
            load_value = 7'd50;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd55);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Reset Priority");
            reset_dut();
            load = 1;
            load_value = 7'h22;
            enable = 1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_load_7 Testbench");
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
        input [6:0] expected_count;
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
        $dumpvars(0,clk, enable, load, load_value, rst, count);
    end

endmodule
