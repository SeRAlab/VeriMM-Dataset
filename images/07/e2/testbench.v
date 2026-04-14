`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [3:0] approx_out;
    wire [3:0] detail_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .approx_out(approx_out),
        .detail_out(detail_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'd0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Constant Input (8, 8)");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd8;
            @(posedge clk);
            data_in = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Positive Difference (12, 4)");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd12;
            @(posedge clk);
            data_in = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd4);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Negative Difference (4, 12)");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd4;
            @(posedge clk);
            data_in = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd12);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Max/Min Range (15, 1)");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd15;
            @(posedge clk);
            data_in = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd7);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Zero Input (0, 0)");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd0;
            @(posedge clk);
            data_in = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Test Case 006: Large Negative Difference (2, 14)");
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'd2;
            @(posedge clk);
            data_in = 4'd14;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [3:0] expected_approx_out;
        input [3:0] expected_detail_out;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h",
                         expected_approx_out, expected_detail_out);
                $display("  Got:      approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
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
        $dumpvars(0,clk, data_in, reset, approx_out, detail_out);
    end

endmodule
