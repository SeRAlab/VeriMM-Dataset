`timescale 1ns/1ps

module pipeline_2stage_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg clk;
    reg rst;
    wire [3:0] sub_out;
    wire [3:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_2stage dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .rst(rst),
        .sub_out(sub_out),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            c = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            a = 4'd5; b = 4'd3; c = 4'd2;

            @(posedge clk);
            @(posedge clk);
            #1;

            $display("Testcase 001: Basic Addition and Subtraction");
            #1;

            check_outputs(4'd6, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            a = 4'd10; b = 4'd10; c = 4'd1;

            @(posedge clk);
            @(posedge clk);
            #1;

            $display("Testcase 002: Addition with Wrap-around");
            #1;

            check_outputs(4'd3, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            a = 4'd2; b = 4'd3; c = 4'd10;

            @(posedge clk);
            @(posedge clk);
            #1;

            $display("Testcase 003: Subtraction with Underflow");
            #1;

            check_outputs(4'hB, 4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            a = 4'd7; b = 4'd9; c = 4'd0;

            @(posedge clk);
            @(posedge clk);
            #1;

            $display("Testcase 004: Results resulting in Zero");
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            a = 4'd15; b = 4'd15; c = 4'd15;

            @(posedge clk);
            @(posedge clk);
            #1;

            $display("Testcase 005: Maximum Value Inputs");
            #1;

            check_outputs(4'hF, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 4'd8; b = 4'd8; c = 4'd4;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;

            $display("Testcase 006: Reset Functionality Check");

            #1;


            check_outputs(4'd0, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_2stage Testbench");
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
        input [3:0] expected_sub_out;
        input [3:0] expected_sum_out;
        begin
            if (expected_sub_out === (expected_sub_out ^ sub_out ^ expected_sub_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: sub_out=%h, sum_out=%h",
                         sub_out, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sub_out=%h, sum_out=%h",
                         expected_sub_out, expected_sum_out);
                $display("  Got:      sub_out=%h, sum_out=%h",
                         sub_out, sum_out);
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
        $dumpvars(0,a, b, c, clk, rst, sub_out, sum_out);
    end

endmodule
