`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    reg valid_in;
    wire [7:0] result;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .result(result),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            valid_in = 0;
            reset = 1;
            repeat (5) @(posedge clk);
            #1;
            reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Addition (15 + 25)");
            reset_dut();
            test_num = test_num + 1;

            a = 8'd15;
            b = 8'd25;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            repeat (6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Zero Addition (0 + 0)");
            reset_dut();
            test_num = test_num + 1;

            a = 8'd0;
            b = 8'd0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            repeat (6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Overflow Check (255 + 2)");
            reset_dut();
            test_num = test_num + 1;

            a = 8'hFF;
            b = 8'h02;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            repeat (6) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running Testcase 004: Consecutive Stream");
            reset_dut();
            test_num = test_num + 1;


            a = 8'd1; b = 8'd1; valid_in = 1; @(posedge clk);
            a = 8'd2; b = 8'd2; valid_in = 1; @(posedge clk);
            a = 8'd3; b = 8'd3; valid_in = 1; @(posedge clk);
            valid_in = 0;


            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd2, 1'b1);

            @(posedge clk); #1;
            #1;

            check_outputs(8'd4, 1'b1);

            @(posedge clk); #1;
            #1;

            check_outputs(8'd6, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Intermittent Inputs");
            reset_dut();
            test_num = test_num + 1;


            a = 8'd10; b = 8'd10; valid_in = 1; @(posedge clk);

            valid_in = 0; repeat(2) @(posedge clk);

            a = 8'd20; b = 8'd20; valid_in = 1; @(posedge clk);
            valid_in = 0;


            repeat (5) @(posedge clk); #1;
            #1;

            check_outputs(8'd20, 1'b1);


            @(posedge clk); #1;
            #1;

            check_outputs(result, 1'b0);

            @(posedge clk); #1;
            #1;

            check_outputs(result, 1'b0);


            @(posedge clk); #1;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_adder Testbench");
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
        input [7:0] expected_result;
        input expected_valid_out;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid_out=%b",
                         result, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid_out=%b",
                         expected_result, expected_valid_out);
                $display("  Got:      result=%h, valid_out=%b",
                         result, valid_out);
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
        $dumpvars(0,a, b, clk, reset, valid_in, result, valid_out);
    end

endmodule
