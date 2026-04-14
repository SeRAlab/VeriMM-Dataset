`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ABCD;
    reg clk;
    reg reset;
    wire [1:0] Y;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABCD(ABCD),
        .clk(clk),
        .reset(reset),
        .Y(Y),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ABCD = 4'b0000;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority 3 (ABCD=1000) and 1 cycle increment", test_num);
            reset_dut();
            ABCD = 4'b1000;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3, 8'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority 2 (ABCD=0110) and 2 cycle increment", test_num);
            reset_dut();
            ABCD = 4'b0110;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2, 8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority 1 (ABCD=0011) and 5 cycle increment", test_num);
            reset_dut();
            ABCD = 4'b0011;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1, 8'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority 0 (ABCD=0001) and 10 cycle increment", test_num);
            reset_dut();
            ABCD = 4'b0001;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input (ABCD=0000)", test_num);
            reset_dut();
            ABCD = 4'b0000;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0, 8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max counter (15 cycles) and Priority 3", test_num);
            reset_dut();
            ABCD = 4'b1111;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3, 8'd18);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter wrap-around (16 cycles)", test_num);
            reset_dut();
            ABCD = 4'b1000;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3, 8'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [1:0] expected_Y;
        input [7:0] expected_sum;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, sum=%h",
                         Y, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, sum=%h",
                         expected_Y, expected_sum);
                $display("  Got:      Y=%h, sum=%h",
                         Y, sum);
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
        $dumpvars(0,ABCD, clk, reset, Y, sum);
    end

endmodule
