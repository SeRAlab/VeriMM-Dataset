`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [3:0] opcode;
    reg reset;
    wire negative;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .opcode(opcode),
        .reset(reset),
        .negative(negative),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in1 = 8'b0;
            in2 = 8'b0;
            opcode = 4'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            in1 = 8'd15;
            in2 = 8'd25;
            opcode = ADD;
            @(posedge clk);
            #1;
            $display("Test %03d: Addition (15 + 25)", test_num);
            #1;

            check_outputs(1'b0, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd20;
            opcode = SUB;
            @(posedge clk);
            #1;
            $display("Test %03d: Subtraction (50 - 20)", test_num);
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            in1 = 8'd20;
            in2 = 8'd50;
            opcode = SUB;
            @(posedge clk);
            #1;
            $display("Test %03d: Subtraction Negative Result (20 - 50)", test_num);
            #1;

            check_outputs(1'b1, 8'hE2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            in1 = 8'd12;
            in2 = 8'd5;
            opcode = MUL;
            @(posedge clk);
            #1;
            $display("Test %03d: Multiplication (12 * 5)", test_num);
            #1;

            check_outputs(1'b0, 8'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            in1 = 8'd80;
            in2 = 8'd4;
            opcode = DIV;
            @(posedge clk);
            #1;
            $display("Test %03d: Division (80 / 4)", test_num);
            #1;

            check_outputs(1'b0, 8'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd100;
            opcode = ADD;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            $display("Test %03d: Reset Check", test_num);
            #1;

            check_outputs(1'b0, 8'd0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            in1 = 8'hFF;
            in2 = 8'h01;
            opcode = ADD;
            @(posedge clk);
            #1;
            $display("Test %03d: Addition Overflow (255 + 1)", test_num);

            #1;


            check_outputs(1'b0, 8'h00);
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
        input expected_negative;
        input [7:0] expected_out;
        begin
            if (expected_negative === (expected_negative ^ negative ^ expected_negative) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: negative=%b, out=%h",
                         negative, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: negative=%b, out=%h",
                         expected_negative, expected_out);
                $display("  Got:      negative=%b, out=%h",
                         negative, out);
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
        $dumpvars(0,clk, in1, in2, opcode, reset, negative, out);
    end

endmodule
