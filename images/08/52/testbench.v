`timescale 1ns/1ps

module dwt_1d_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] signal_in;
    wire [7:0] approx_out;
    wire [7:0] detail_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_1d dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
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
            rst = 1;
            signal_in = 16'h0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Zero Input");
            reset_dut();
            signal_in = 16'h0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Constant Signal (DC)");
            reset_dut();
            signal_in = 16'h8080;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h80, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Step Up Signal");
            reset_dut();
            signal_in = 16'hFF00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h7F, 8'h7F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Step Down Signal");
            reset_dut();
            signal_in = 16'h00FF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h7F, 8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Arbitrary Values");
            reset_dut();
            signal_in = 16'h4020;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h30, 8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Max Values");
            reset_dut();
            signal_in = 16'hFFFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_1d Testbench");
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
        input [7:0] expected_approx_out;
        input [7:0] expected_detail_out;
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
        $dumpvars(0,clk, rst, signal_in, approx_out, detail_out);
    end

endmodule
