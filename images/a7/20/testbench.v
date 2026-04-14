`timescale 1ns/1ps

module binary_down_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_down_counter_3bit dut (
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
            @(posedge clk);
            rst <= 1;
            en <= 0;
            @(posedge clk);
            #1;
            rst <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Initial Reset to 7", test_num);
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Single Decrement (7 to 6)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            @(posedge clk);
            en <= 0;
            @(negedge clk);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Multiple Decrements (7 down to 3)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            repeat(4) @(posedge clk);
            en <= 0;
            @(negedge clk);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Wrap Around (Full Cycle)", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            repeat(8) @(posedge clk);
            en <= 0;
            @(negedge clk);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Enable Low Hold Logic", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            repeat(2) @(posedge clk);
            en <= 0;
            repeat(3) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Intermittent Enable", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            repeat(2) @(posedge clk);
            en <= 0;
            @(posedge clk);
            en <= 1;
            @(posedge clk);
            en <= 0;
            @(negedge clk);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Count down to Zero", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            repeat(7) @(posedge clk);
            en <= 0;
            @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_down_counter_3bit Testbench");
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
        input [2:0] expected_count;
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
