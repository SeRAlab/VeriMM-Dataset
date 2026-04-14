`timescale 1ns/1ps

module async_up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [63:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    async_up_counter dut (
        .clk(clk),
        .en(en),
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
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Counting (10 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(64'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable/Disable Toggle Logic", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            en = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(64'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            en = 1;
            repeat(20) @(posedge clk);
            #3;
            rst = 1;
            #10;
            rst = 0;
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Extended Counting (255 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(255) @(posedge clk);
            #2;
            #1;

            check_outputs(64'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset Overrides Enable", test_num);
            reset_dut();
            rst = 1;
            en = 1;
            repeat(5) @(posedge clk);
            rst = 0;
            en = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("async_up_counter Testbench");
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
        input [63:0] expected_count;
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
        $dumpvars(0,clk, en, rst, count);
    end

endmodule
