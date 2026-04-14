`timescale 1ns/1ps

module PISO_4_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] PI;
    reg clk;
    reg load;
    reg rst;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO_4 dut (
        .PI(PI),
        .clk(clk),
        .load(load),
        .rst(rst),
        .SO(SO)
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
            PI = 4'b0000;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 4'b1011 and shift 3 times", test_num);
            reset_dut();
            PI = 4'b1011;
            load = 1;
            @(negedge clk);
            load = 0;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 4'b1100 and check LSB", test_num);
            reset_dut();
            PI = 4'b1100;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous reset priority", test_num);
            reset_dut();
            PI = 4'b1111;
            load = 1;
            rst = 1;
            @(negedge clk);
            rst = 0;
            load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift 4 times to empty register", test_num);
            reset_dut();
            PI = 4'b1111;
            load = 1;
            @(negedge clk);
            load = 0;
            repeat(4) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive Load operations", test_num);
            reset_dut();
            PI = 4'b1010;
            load = 1;
            @(negedge clk);
            PI = 4'b0101;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO_4 Testbench");
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
        input expected_SO;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: SO=%b",
                         SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%b",
                         expected_SO);
                $display("  Got:      SO=%b",
                         SO);
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
        $dumpvars(0,PI, clk, load, rst, SO);
    end

endmodule
