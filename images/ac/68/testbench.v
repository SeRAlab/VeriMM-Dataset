`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ctrl;
    reg [15:0] op1;
    reg [15:0] op2;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .op1(op1),
        .op2(op2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (16'h1234 + 16'h1111)", test_num);
        ctrl = 3'b001;
        op1 = 16'h1234;
        op2 = 16'h1111;
        #1;

        check_outputs(16'h2345);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Overflow (16'hFFFF + 16'h0001)", test_num);
        ctrl = 3'b001;
        op1 = 16'hFFFF;
        op2 = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (16'h000A - 16'h0003)", test_num);
        ctrl = 3'b010;
        op1 = 16'h000A;
        op2 = 16'h0003;
        #1;

        check_outputs(16'h0007);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Underflow (16'h0000 - 16'h0001)", test_num);
        ctrl = 3'b010;
        op1 = 16'h0000;
        op2 = 16'h0001;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (16'hF0F0 | 16'h0F0F)", test_num);
        ctrl = 3'b011;
        op1 = 16'hF0F0;
        op2 = 16'h0F0F;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (16'hAAAA | 16'h5555)", test_num);
        ctrl = 3'b011;
        op1 = 16'hAAAA;
        op2 = 16'h5555;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift Left (16'h0001 << 4)", test_num);
        ctrl = 3'b100;
        op1 = 16'h0001;
        op2 = 16'h0004;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift Left out all bits (16'hFFFF << 16)", test_num);
        ctrl = 3'b100;
        op1 = 16'hFFFF;
        op2 = 16'h0010;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift Right (16'h8000 >> 1)", test_num);
        ctrl = 3'b101;
        op1 = 16'h8000;
        op2 = 16'h0001;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift Right (16'h0010 >> 4)", test_num);
        ctrl = 3'b101;
        op1 = 16'h0010;
        op2 = 16'h0004;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Compare Less Than (True: 5 < 10)", test_num);
        ctrl = 3'b110;
        op1 = 16'h0005;
        op2 = 16'h000A;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Compare Less Than (False: 10 < 5)", test_num);
        ctrl = 3'b110;
        op1 = 16'h000A;
        op2 = 16'h0005;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Compare Less Than (False: 5 < 5)", test_num);
        ctrl = 3'b110;
        op1 = 16'h0005;
        op2 = 16'h0005;
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
