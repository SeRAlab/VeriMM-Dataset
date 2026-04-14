`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg [1:0] op;
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
        .op(op),
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
        data_a = 8'h0;
        data_b = 8'h0;
        op = 2'b10;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Addition (10 + 20)", test_num);
        reset_dut();


        data_a = 8'd10;
        data_b = 8'd20;
        op = 2'b00;

        @(posedge clk);

        op = 2'b10;
        data_a = 0;
        data_b = 0;


        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Subtraction (50 - 15)", test_num);
        reset_dut();

        data_a = 8'd50;
        data_b = 8'd15;
        op = 2'b01;

        @(posedge clk);
        op = 2'b10;

        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: NOP Operation", test_num);
        reset_dut();


        data_a = 8'd100;
        data_b = 8'd50;
        op = 2'b10;

        @(posedge clk);
        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Overflow (200 + 100)", test_num);
        reset_dut();

        data_a = 8'd200;
        data_b = 8'd100;
        op = 2'b00;

        @(posedge clk);
        op = 2'b10;

        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(8'd44);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Underflow (10 - 20)", test_num);
        reset_dut();

        data_a = 8'd10;
        data_b = 8'd20;
        op = 2'b01;

        @(posedge clk);
        op = 2'b10;

        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(8'd246);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Result (25 - 25)", test_num);
        reset_dut();

        data_a = 8'd25;
        data_b = 8'd25;
        op = 2'b01;

        @(posedge clk);
        op = 2'b10;

        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
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
        $dumpvars(0,clk, data_a, data_b, op, rst, result);
    end

endmodule
