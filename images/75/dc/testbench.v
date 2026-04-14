`timescale 1ns/1ps

module sync_down_counter_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [31:0] load_value;
    reg rst;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_down_counter_32bit dut (
        .clk(clk),
        .en(en),
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
            @(posedge clk);
            rst <= 1;
            en <= 0;
            load <= 0;
            load_value <= 0;
            @(posedge clk);
            rst <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Loading and Counting", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            load_value <= 32'd100;

            @(posedge clk);
            load <= 0;
            en <= 1;

            repeat(5) @(posedge clk);

            en <= 0;
            #1;

            check_outputs(32'd95);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reset Priority over Load and Enable", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            load_value <= 32'hFFFFFFFF;
            en <= 1;
            rst <= 1;

            @(posedge clk);
            rst <= 0;
            en <= 0;
            load <= 0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load Priority over Enable", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            load_value <= 32'hABCDE123;
            en <= 1;

            @(posedge clk);
            load <= 0;
            en <= 0;

            #1;


            check_outputs(32'hABCDE123);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Wraparound Check (0 to Max)", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            load_value <= 32'd1;

            @(posedge clk);
            load <= 0;
            en <= 1;

            repeat(2) @(posedge clk);

            en <= 0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Enable Hold Logic", test_num);
            reset_dut();

            @(posedge clk);
            load <= 1;
            load_value <= 32'd50;

            @(posedge clk);
            load <= 0;
            en <= 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_down_counter_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_count;
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
        $dumpvars(0,clk, en, load, load_value, rst, count);
    end

endmodule
