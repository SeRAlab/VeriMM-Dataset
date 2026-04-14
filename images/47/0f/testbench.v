`timescale 1ns/1ps

module binary_counter_12bit_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data;
    reg load;
    reg rst;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_12bit_with_load dut (
        .clk(clk),
        .data(data),
        .load(load),
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
        load = 0;
        data = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Reset and Increment 10 cycles");
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(12'd10);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Load value 12'hABC");
        reset_dut();
        data = 12'hABC;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(12'hABC);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Load 12'h500 then increment 5 times");
        reset_dut();
        data = 12'h500;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h505);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Incrementing past 12'hFFF (Wraparound)");
        reset_dut();
        data = 12'hFFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Reset priority over Load");
        reset_dut();
        data = 12'hFFF;
        load = 1;
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        load = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Changing load data immediately");
        reset_dut();
        data = 12'h123;
        load = 1;
        @(posedge clk);
        #1;
        data = 12'h456;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(12'h456);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_12bit_with_load Testbench");
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
        input [11:0] expected_count;
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
        $dumpvars(0,clk, data, load, rst, count);
    end

endmodule
