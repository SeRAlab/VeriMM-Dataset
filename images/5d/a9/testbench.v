`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] ctrl;
    reg [31:0] data1;
    reg [31:0] data2;
    wire oCarry;
    wire oZero;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .data1(data1),
        .data2(data2),
        .oCarry(oCarry),
        .oZero(oZero),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data1 = 32'h0;
            data2 = 32'h0;
            ctrl = OP_INV;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data1 = 32'd100;
            data2 = 32'd250;
            ctrl  = OP_ADD;
            @(posedge clk);
            #1;
            $display("Test 001: Simple Addition");
            #1;

            check_outputs(1'b0, 1'b0, 32'd350);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data1 = 32'hFFFFFFFF;
            data2 = 32'h00000001;
            ctrl  = OP_ADD;
            @(posedge clk);
            #1;
            $display("Test 002: Addition causing Overflow/Carry");
            #1;

            check_outputs(1'b1, 1'b1, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data1 = 32'd500;
            data2 = 32'd150;
            ctrl  = OP_SUB;
            @(posedge clk);
            #1;
            $display("Test 003: Simple Subtraction");
            #1;

            check_outputs(1'b0, 1'b0, 32'd350);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data1 = 32'd10;
            data2 = 32'd20;
            ctrl  = OP_SUB;
            @(posedge clk);
            #1;
            $display("Test 004: Subtraction causing Borrow");


            #1;



            check_outputs(1'b1, 1'b0, 32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data1 = 32'hF0F0F0F0;
            data2 = 32'hAAAA_AAAA;
            ctrl  = OP_AND;
            @(posedge clk);
            #1;
            $display("Test 005: Bitwise AND");
            #1;

            check_outputs(1'b0, 1'b0, 32'hA0A0A0A0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data1 = 32'hF0F0F0F0;
            data2 = 32'h0F0F0F0F;
            ctrl  = OP_OR;
            @(posedge clk);
            #1;
            $display("Test 006: Bitwise OR");
            #1;

            check_outputs(1'b0, 1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            data1 = 32'h12345678;
            data2 = 32'h12345678;
            ctrl  = OP_XOR;
            @(posedge clk);
            #1;
            $display("Test 007: Bitwise XOR (Identical Inputs)");
            #1;

            check_outputs(1'b0, 1'b1, 32'h00000000);
        end
        endtask

    task testcase008;

        begin

            data1 = 32'hFFFFFFFF;
            data2 = 32'hFFFFFFFF;
            ctrl  = OP_ADD;
            @(posedge clk);
            #1;


            ctrl  = 3'b110;
            @(posedge clk);
            #1;
            $display("Test 008: Invalid Control Signal Reset");
            #1;

            check_outputs(1'b0, 1'b1, 32'h00000000);

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
        input expected_oCarry;
        input expected_oZero;
        input [31:0] expected_out;
        begin
            if (expected_oCarry === (expected_oCarry ^ oCarry ^ expected_oCarry) &&
                expected_oZero === (expected_oZero ^ oZero ^ expected_oZero) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: oCarry=%b, oZero=%b, out=%h",
                         oCarry, oZero, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCarry=%b, oZero=%b, out=%h",
                         expected_oCarry, expected_oZero, expected_out);
                $display("  Got:      oCarry=%b, oZero=%b, out=%h",
                         oCarry, oZero, out);
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
        $dumpvars(0,clk, ctrl, data1, data2, oCarry, oZero, out);
    end

endmodule
