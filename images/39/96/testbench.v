`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg rst;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .rst(rst),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_a = 0;
            data_b = 0;
            @(posedge clk);
            #1;
            rst = 0;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Addition (12 + 34)");
            reset_dut();
            data_a = 8'd12;
            data_b = 8'd34;
            @(posedge clk);
            data_a = 0;
            data_b = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd46);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Overflow Handling (250 + 10)");
            reset_dut();
            data_a = 8'd250;
            data_b = 8'd10;
            @(posedge clk);
            data_a = 0;
            data_b = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Zero Inputs (0 + 0)");
            reset_dut();
            data_a = 8'd0;
            data_b = 8'd0;
            @(posedge clk);
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Pipeline Throughput (Streaming)");
            reset_dut();

            data_a = 8'd1; data_b = 8'd1; @(posedge clk);
            data_a = 8'd2; data_b = 8'd2; @(posedge clk);
            data_a = 8'd3; data_b = 8'd3; @(posedge clk);
            data_a = 8'd4; data_b = 8'd4; @(posedge clk);
            data_a = 8'd5; data_b = 8'd5; @(posedge clk);

            data_a = 0; data_b = 0;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Maximum Values (255 + 255)");
            reset_dut();
            data_a = 8'hFF;
            data_b = 8'hFF;
            @(posedge clk);
            data_a = 0;
            data_b = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd254);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data_a, data_b, rst, result);
    end

endmodule
