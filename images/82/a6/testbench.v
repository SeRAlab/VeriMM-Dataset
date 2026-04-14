`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] op;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        op = 4'd0; a = 32'h00000005; b = 32'h0000000A;
        $display("Test %0d: Addition (5 + 10)", test_num);
        #1;

        check_outputs(32'h0000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op = 4'd1; a = 32'h00000014; b = 32'h00000006;
        $display("Test %0d: Subtraction (20 - 6)", test_num);
        #1;

        check_outputs(32'h0000000E);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op = 4'd2; a = 32'hF0F0F0F0; b = 32'hAAAAFFFF;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hA0A0F0F0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op = 4'd3; a = 32'hF0F0F0F0; b = 32'h0F0F0F0F;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op = 4'd4; a = 32'h12345678; b = 32'h1234FFFF;
        $display("Test %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(32'h0000A987);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op = 4'd5; a = 32'h00000001; b = 32'h00000004;
        $display("Test %0d: Logical Shift Left (1 << 4)", test_num);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op = 4'd6; a = 32'h00000080; b = 32'h00000003;
        $display("Test %0d: Logical Shift Right (128 >> 3)", test_num);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        op = 4'd7; a = 32'hFFFFFFFF; b = 32'h00000001;
        $display("Test %0d: SLT (-1 < 1)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        op = 4'd8; a = 32'h0000000A; b = 32'h0000000A;
        $display("Test %0d: SLE (10 <= 10)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        op = 4'd9; a = 32'h12345678; b = 32'h12345678;
        $display("Test %0d: SEQ (Equal)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        op = 4'd10; a = 32'hFFFFFFFF; b = 32'hABCD1234;
        $display("Test %0d: Zero-extend lower 16 bits", test_num);
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        op = 4'd11; a = 32'h00000002; b = 32'h00000002;
        $display("Test %0d: Combined Operation", test_num);

        #1;


        check_outputs(32'h00000002);
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
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
