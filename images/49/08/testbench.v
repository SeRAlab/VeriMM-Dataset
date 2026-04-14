`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ctrl;
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (Normal)", test_num);
        ctrl = 3'b000; in1 = 16'h1234; in2 = 16'h1111;
        #1;

        check_outputs(16'h2345);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Addition (Overflow/Wrap)", test_num);
        ctrl = 3'b000; in1 = 16'hFFFF; in2 = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Subtraction (Normal)", test_num);
        ctrl = 3'b001; in1 = 16'h0020; in2 = 16'h0005;
        #1;

        check_outputs(16'h001B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Subtraction (Underflow/Wrap)", test_num);
        ctrl = 3'b001; in1 = 16'h0000; in2 = 16'h0001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Bitwise OR", test_num);
        ctrl = 3'b010; in1 = 16'hAAAA; in2 = 16'h5555;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Comparison (True: in1 < in2)", test_num);
        ctrl = 3'b011; in1 = 16'h0005; in2 = 16'h000A;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Comparison (False: in1 > in2)", test_num);
        ctrl = 3'b011; in1 = 16'h000A; in2 = 16'h0005;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Left Shift", test_num);
        ctrl = 3'b100; in1 = 16'h0001; in2 = 16'h0004;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Right Shift", test_num);
        ctrl = 3'b101; in1 = 16'h0010; in2 = 16'h0004;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Full Zero Input Logic", test_num);
        ctrl = 3'b010; in1 = 16'h0000; in2 = 16'h0000;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
