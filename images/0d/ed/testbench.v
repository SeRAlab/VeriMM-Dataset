`timescale 1ns/1ps

module pipelined_multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    reg valid;
    wire ready;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .ready(ready),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            a = 0;
            b = 0;

            repeat (2) @(posedge clk);
            #1;
            reset = 0;

            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: 5 * 4 = 20");
            reset_dut();
            test_num = 1;
            @(negedge clk);
            a = 8'd5;
            b = 8'd4;
            valid = 1;
            @(negedge clk);
            valid = 0;

            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd20);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: 255 * 255 = 65025");
            reset_dut();
            test_num = 2;
            @(negedge clk);
            a = 8'd255;
            b = 8'd255;
            valid = 1;
            @(negedge clk);
            valid = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd65025);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: 128 * 0 = 0");
            reset_dut();
            test_num = 3;
            @(negedge clk);
            a = 8'd128;
            b = 8'd0;
            valid = 1;
            @(negedge clk);
            valid = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: 1 * 255 = 255");
            reset_dut();
            test_num = 4;
            @(negedge clk);
            a = 8'd1;
            b = 8'd255;
            valid = 1;
            @(negedge clk);
            valid = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd255);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Pipeline Stream Test (Check 10 * 10 = 100)");
            reset_dut();
            test_num = 5;
            @(negedge clk);

            a = 8'd2; b = 8'd2; valid = 1;
            @(negedge clk);

            a = 8'd3; b = 8'd3;
            @(negedge clk);

            a = 8'd4; b = 8'd4;
            @(negedge clk);

            a = 8'd5; b = 8'd5;
            @(negedge clk);

            a = 8'd10; b = 8'd10;
            @(negedge clk);
            valid = 0;


            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd100);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: 0 * 0 = 0");
            reset_dut();
            test_num = 6;
            @(negedge clk);
            a = 8'd0;
            b = 8'd0;
            valid = 1;
            @(negedge clk);
            valid = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: 16 * 16 = 256");
            reset_dut();
            test_num = 7;
            @(negedge clk);
            a = 8'd16;
            b = 8'd16;
            valid = 1;
            @(negedge clk);
            valid = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(1'b1, 16'd256);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_multiplier Testbench");
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
        input expected_ready;
        input [15:0] expected_result;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, result=%h",
                         ready, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, result=%h",
                         expected_ready, expected_result);
                $display("  Got:      ready=%b, result=%h",
                         ready, result);
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
        $dumpvars(0,a, b, clk, reset, valid, ready, result);
    end

endmodule
