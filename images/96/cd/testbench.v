`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] ahigh;
    reg [15:0] b;
    reg ci;
    reg [3:0] func;
    reg use32bit;
    wire co;
    wire negative;
    wire overflow;
    wire [15:0] y;
    wire [15:0] yhigh;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ahigh(ahigh),
        .b(b),
        .ci(ci),
        .func(func),
        .use32bit(use32bit),
        .co(co),
        .negative(negative),
        .overflow(overflow),
        .y(y),
        .yhigh(yhigh),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 16-bit Addition (a + b)", test_num);
        a = 16'h1234; b = 16'h1111; ci = 0; func = 4'd0; use32bit = 0; ahigh = 0;

        #1;


        check_outputs(0, 0, 0, 16'h2345, 16'h0000, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 16-bit Addition with Carry Out", test_num);
        a = 16'hFFFF; b = 16'h0001; ci = 0; func = 4'd0; use32bit = 0; ahigh = 0;

        #1;


        check_outputs(1, 0, 0, 16'h0000, 16'h0000, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 32-bit Addition ({ahigh, a} + b)", test_num);
        ahigh = 16'h0001; a = 16'h8000; b = 16'h8001; ci = 0; func = 4'd0; use32bit = 1;


        #1;



        check_outputs(0, 0, 0, 16'h0001, 16'h0002, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication", test_num);
        a = 16'h0100; b = 16'h0100; func = 4'd2; use32bit = 0;


        #1;



        check_outputs(0, 0, 0, 16'h0000, 16'h0001, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        a = 16'hF0F0; b = 16'hAAAA; func = 4'd3; use32bit = 0;

        #1;


        check_outputs(0, 1, 0, 16'hA0A0, 16'h0000, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        a = 16'hFFFF; b = 16'h1234; func = 4'd5; use32bit = 0;

        #1;


        check_outputs(0, 1, 0, 16'hEDCB, 16'h0000, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOT", test_num);
        a = 16'h0000; func = 4'd6; use32bit = 0;

        #1;


        check_outputs(0, 1, 0, 16'hFFFF, 16'h0000, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Left Logical", test_num);
        a = 16'h0001; b = 16'h0004; func = 4'd7; use32bit = 0;

        #1;


        check_outputs(0, 0, 0, 16'h0010, 16'h0000, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Right Arithmetic", test_num);
        a = 16'h8000; b = 16'h0004; func = 4'd9; use32bit = 0;

        #1;


        check_outputs(0, 1, 0, 16'hF800, 16'h0000, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotate Left", test_num);
        a = 16'h8001; b = 16'h0001; func = 4'd10; use32bit = 0;

        #1;


        check_outputs(0, 0, 0, 16'h0003, 16'h0000, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow Check (Pos + Pos = Neg)", test_num);
        a = 16'h7FFF; b = 16'h0001; ci = 0; func = 4'd0; use32bit = 0;

        #1;


        check_outputs(0, 1, 1, 16'h8000, 16'h0000, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Flag", test_num);
        a = 16'h1234; b = 16'h1234; func = 4'd5; use32bit = 0;

        #1;


        check_outputs(0, 0, 0, 16'h0000, 16'h0000, 1);
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
        input expected_co;
        input expected_negative;
        input expected_overflow;
        input [15:0] expected_y;
        input [15:0] expected_yhigh;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_co === (expected_co ^ co ^ expected_co) &&
                expected_negative === (expected_negative ^ negative ^ expected_negative) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_yhigh === (expected_yhigh ^ yhigh ^ expected_yhigh) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: co=%b, negative=%b, overflow=%b, y=%h, yhigh=%h, zero=%b",
                         co, negative, overflow, y, yhigh, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co=%b, negative=%b, overflow=%b, y=%h, yhigh=%h, zero=%b",
                         expected_co, expected_negative, expected_overflow, expected_y, expected_yhigh, expected_zero);
                $display("  Got:      co=%b, negative=%b, overflow=%b, y=%h, yhigh=%h, zero=%b",
                         co, negative, overflow, y, yhigh, zero);
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

endmodule
