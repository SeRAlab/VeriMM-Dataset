`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg [2:0] op;
    reg rst;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .rst(rst),
        .result(result),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            A = 0;
            B = 0;
            op = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 32'd100; B = 32'd50; op = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd150, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 32'h0; B = 32'h0; op = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 32'd100; B = 32'd40; op = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd60, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 32'hFFFF; B = 32'hFFFF; op = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 32'hF0F0F0F0; B = 32'hAAAA_AAAA; op = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hA0A0A0A0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; op = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 32'h12345678; B = 32'h12345678; op = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 32'd10; B = 32'd20; op = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            A = 32'd50; B = 32'd20; op = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            A = 32'hFFFFFFFF; B = 32'h1; op = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            A = 32'd0; B = 32'd1; op = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
        $dumpvars(0,A, B, clk, op, rst, result, zero);
    end

endmodule
