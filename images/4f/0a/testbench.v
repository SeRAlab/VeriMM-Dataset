`timescale 1ns/1ps

module binary_counter_load_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_value;
    reg rst;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_load_8bit dut (
        .clk(clk),
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
            @(negedge clk);
            rst = 1;
            load = 0;
            load_value = 8'h00;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Reset Check");
            reset_dut();

            repeat(5) @(negedge clk);

            @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Incrementing (Count to 10)");
            reset_dut();

            repeat(10) @(negedge clk);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load Specified Value");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'hA5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Count after loading a value");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'h20;
            @(negedge clk);
            load = 0;

            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'h25);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Counter Rollover (FF -> 00)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'hFF;
            @(negedge clk);
            load = 0;

            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Continuous Load Check");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'h55;
            @(negedge clk);
            load_value = 8'hAA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset priority over Load");
            reset_dut();
            @(negedge clk);
            rst = 1;
            load = 1;
            load_value = 8'hFF;
            @(negedge clk);
            rst = 0;
            load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_load_8bit Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, load, load_value, rst, count);
    end

endmodule
