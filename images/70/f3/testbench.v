`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] input1;
    reg [31:0] input2;
    reg [3:0] op;
    reg reset;
    wire overflow;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .op(op),
        .reset(reset),
        .overflow(overflow),
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
            reset = 1;
            input1 = 0;
            input2 = 0;
            op = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: AND Operation", test_num);
            op = 4'b0000;
            input1 = 32'hAAAA_5555;
            input2 = 32'hFFFF_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'hAAAA_0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: OR Operation", test_num);
            op = 4'b0001;
            input1 = 32'hAAAA_5555;
            input2 = 32'h5555_AAAA;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: ADD No Overflow", test_num);
            op = 4'b010;
            input1 = 32'd100;
            input2 = 32'd250;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'd350, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: ADD With Overflow (Positive)", test_num);
            op = 4'b010;
            input1 = 32'h7FFF_FFFF;
            input2 = 32'h0000_0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'h8000_0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: SUB Zero Flag", test_num);
            op = 4'b0110;
            input1 = 32'h1234_5678;
            input2 = 32'h1234_5678;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: SUB With Overflow (Negative)", test_num);
            op = 4'b0110;
            input1 = 32'h8000_0000;
            input2 = 32'h0000_0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 32'h7FFF_FFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: SLT (True)", test_num);
            op = 4'b0111;
            input1 = 32'hFFFF_FFFF;
            input2 = 32'h0000_0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'd1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: SLT (False)", test_num);
            op = 4'b0111;
            input1 = 32'd10;
            input2 = 32'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Test %0d: SLL", test_num);
            op = 4'b0100;
            input1 = 32'h0000_0001;
            input2 = 32'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'h0000_0010, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Test %0d: SRA Sign Extension", test_num);
            op = 4'b1000;
            input1 = 32'h8000_0000;
            input2 = 32'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'hC000_0000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = 11;
            $display("Test %0d: SRL", test_num);
            op = 4'b0101;
            input1 = 32'h8000_0000;
            input2 = 32'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'h4000_0000, 1'b0);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            test_num = 12;
            $display("Test %0d: XOR", test_num);
            op = 4'b0011;
            input1 = 32'hF0F0_F0F0;
            input2 = 32'hFFFF_FFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 32'h0F0F_0F0F, 1'b0);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h, zero=%b",
                         expected_overflow, expected_result, expected_zero);
                $display("  Got:      overflow=%b, result=%h, zero=%b",
                         overflow, result, zero);
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
        $dumpvars(0,clk, input1, input2, op, reset, overflow, result, zero);
    end

endmodule
