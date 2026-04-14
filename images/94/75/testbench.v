`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg en;
    reg rst;
    reg sub;
    wire overflow;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .en(en),
        .rst(rst),
        .sub(sub),
        .overflow(overflow),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        en = 0;
        forever #5 en = ~en;
    end

        task reset_dut;

    begin
        rst = 1;
        A = 0;
        B = 0;
        sub = 0;
        @(posedge en);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        A = 4'd2;
        B = 4'd3;
        sub = 0;
        @(posedge en);
        #1;
        $display("Testcase %0d: Addition 2 + 3", test_num);
        #1;

        check_outputs(1'b0, 4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        A = 4'b0111;
        B = 4'b0001;
        sub = 0;
        @(posedge en);
        #1;
        $display("Testcase %0d: Addition 7 + 1 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        A = 4'b1000;
        B = 4'b1111;
        sub = 0;
        @(posedge en);
        #1;
        $display("Testcase %0d: Addition -8 + -1 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 4'b0111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        A = 4'd5;
        B = 4'd2;
        sub = 1;
        @(posedge en);
        #1;
        $display("Testcase %0d: Subtraction 5 - 2", test_num);
        #1;

        check_outputs(1'b0, 4'b0011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        A = 4'b0111;
        B = 4'b1110;
        sub = 1;
        @(posedge en);
        #1;
        $display("Testcase %0d: Subtraction 7 - (-2) (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 4'b1001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        A = 4'b1000;
        B = 4'b0010;
        sub = 1;
        @(posedge en);
        #1;
        $display("Testcase %0d: Subtraction -8 - 2 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 4'b0110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        A = 4'b1011;
        B = 4'b1110;
        sub = 1;
        @(posedge en);
        #1;
        $display("Testcase %0d: Subtraction -5 - (-2)", test_num);
        #1;

        check_outputs(1'b0, 4'b1101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        rst = 1;
        A = 4'd5;
        B = 4'd5;
        @(posedge en);
        #1;
        $display("Testcase %0d: Verify Reset holds outputs at zero", test_num);
        #1;

        check_outputs(1'b0, 4'b0000);
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
        input [3:0] expected_sum;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
        $dumpvars(0,A, B, en, rst, sub, overflow, sum);
    end

endmodule
