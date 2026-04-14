`timescale 1ns/1ps

module up_counter_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst_n;
    wire [11:0] count;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter_12bit dut (
        .clk(clk),
        .enable(enable),
        .rst_n(rst_n),
        .count(count),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            rst_n = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(12'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Increment (10 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Enable/Disable Check", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Terminal Count Check (at 4095)", test_num);
            reset_dut();
            enable = 1;
            repeat(4095) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd4095, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Wrap-around Check (4095 -> 0)", test_num);
            reset_dut();
            enable = 1;
            repeat(4096) @(posedge clk);
            #1;
            #1;

            check_outputs(12'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Mid-count Reset Check", test_num);
            reset_dut();
            enable = 1;
            repeat(100) @(posedge clk);
            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'd0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter_12bit Testbench");
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
        input expected_tc;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: count=%h, tc=%b",
                         count, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, tc=%b",
                         expected_count, expected_tc);
                $display("  Got:      count=%h, tc=%b",
                         count, tc);
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
        $dumpvars(0,clk, enable, rst_n, count, tc);
    end

endmodule
