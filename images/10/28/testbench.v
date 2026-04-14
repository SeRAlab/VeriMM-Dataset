`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [1:0] op;
    reg reset;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .data_in(data_in),
        .op(op),
        .reset(reset),
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
            data_in = 0;
            op = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Addition (0 + 45)");
            reset_dut();
            data_in = 8'd45; op = ADD;
            @(posedge clk); #1;

            data_in = 8'd0; op = ADD;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(16'd45);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Basic Subtraction (Start 100, Sub 30)");
            reset_dut();
            data_in = 8'd100; op = ADD;
            @(posedge clk); #1;
            data_in = 8'd30;  op = SUB;
            @(posedge clk); #1;
            data_in = 8'd0;   op = ADD;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(16'd70);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Multiplication (5 * 12)");
            reset_dut();
            data_in = 8'd5;  op = ADD;
            @(posedge clk); #1;
            data_in = 8'd12; op = MUL;
            @(posedge clk); #1;
            data_in = 8'd0;  op = ADD;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Division (80 / 4)");
            reset_dut();
            data_in = 8'd80; op = ADD;
            @(posedge clk); #1;
            data_in = 8'd4;  op = DIV;
            @(posedge clk); #1;
            data_in = 8'd0;  op = ADD;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(16'd20);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Pipeline Forwarding Sequence ((10 + 20) * 3 - 10)");
            reset_dut();

            data_in = 8'd10; op = ADD;
            @(posedge clk); #1;

            data_in = 8'd20; op = ADD;
            @(posedge clk); #1;

            data_in = 8'd3;  op = MUL;
            @(posedge clk); #1;

            data_in = 8'd10; op = SUB;
            @(posedge clk); #1;

            data_in = 8'd0;  op = ADD;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(16'd80);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Large Values (255 * 2)");
            reset_dut();
            data_in = 8'd255; op = ADD;
            @(posedge clk); #1;
            data_in = 8'd2;   op = MUL;
            @(posedge clk); #1;
            data_in = 8'd0;   op = ADD;
            repeat(7) @(posedge clk);
            #1 #1;
 check_outputs(16'd510);
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
        input [15:0] expected_result;
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
        $dumpvars(0,clk, data_in, op, reset, result);
    end

endmodule
