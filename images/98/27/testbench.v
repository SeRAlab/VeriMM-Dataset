`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg op;
    reg rst;
    wire overflow;
    wire [7:0] result;
    wire valid;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .rst(rst),
        .overflow(overflow),
        .result(result),
        .valid(valid),
        .zero(zero)
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
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 8'd10; b = 8'd20; op = ADD;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd30, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 8'd200; b = 8'd100; op = ADD;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd44, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 8'd50; b = 8'd20; op = SUB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd30, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 8'd15; b = 8'd15; op = SUB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 8'd10; b = 8'd20; op = SUB;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'hF6, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 8'd12; b = 8'd10; op = MUL;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd120, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 8'd50; b = 8'd10; op = MUL;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd244, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            a = 8'd255; b = 8'd0; op = MUL;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            a = 8'd100; b = 8'd4; op = DIV;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd25, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            a = 8'd5; b = 8'd10; op = DIV;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            a = 8'd50; b = 8'd0; op = DIV;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase012;

        begin
            a = 8'd10; b = 8'd10; op = ADD;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 1'b0, 1'b1);
            rst = 0;
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_overflow;
        input [7:0] expected_result;
        input expected_valid;
        input expected_zero;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, valid=%b, zero=%b",
                         overflow, result, valid, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, valid=%b, zero=%b",
                         expected_overflow, expected_result, expected_valid, expected_zero);
                $display("  Got:      overflow=%b, result=%h, valid=%b, zero=%b",
                         overflow, result, valid, zero);
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
        $dumpvars(0,a, b, clk, op, rst, overflow, result, valid, zero);
    end

endmodule
