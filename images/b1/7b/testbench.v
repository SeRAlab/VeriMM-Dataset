`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [15:0] preset_value;
    reg rst;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clk(clk),
        .en(en),
        .load(load),
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
            rst = 1;
            en = 0;
            load = 0;
            preset_value = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Reset");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counting for 10 cycles");
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
            $display("Testcase 003: Load preset value 0xA5A5");
            reset_dut();
            preset_value = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Load 0x1000 and count 5 times");
            reset_dut();
            preset_value = 16'h1000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1005);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pause counting using enable");
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1 en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Check rollover (0xFFFF to 0x0000)");
            reset_dut();
            preset_value = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load priority over enable");
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            preset_value = 16'h7777;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load large value and count");
            reset_dut();
            preset_value = 16'hFFFE;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        $dumpvars(0,clk, en, load, preset_value, rst, count);
    end

endmodule
