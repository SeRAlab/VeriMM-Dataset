`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] op;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Addition (10 + 20)", test_num);
        A = 32'd10;
        B = 32'd20;
        op = 2'b00;
        #1;

        check_outputs(32'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Addition (Max + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        op = 2'b00;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Subtraction (100 - 40)", test_num);
        A = 32'd100;
        B = 32'd40;
        op = 2'b01;
        #1;

        check_outputs(32'd60, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Subtraction (50 - 50)", test_num);
        A = 32'd50;
        B = 32'd50;
        op = 2'b01;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Subtraction (10 - 20)", test_num);
        A = 32'd10;
        B = 32'd20;
        op = 2'b01;
        #1;

        check_outputs(32'hFFFFFFF6, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bitwise AND", test_num);
        A = 32'hF0F0F0F0;
        B = 32'hFF00FF00;
        op = 2'b10;
        #1;

        check_outputs(32'hF000F000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Bitwise AND (Zero result)", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        op = 2'b10;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Bitwise OR", test_num);
        A = 32'h12340000;
        B = 32'h00005678;
        op = 2'b11;
        #1;

        check_outputs(32'h12345678, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Bitwise OR (All ones)", test_num);
        A = 32'hFFFF0000;
        B = 32'h0000FFFF;
        op = 2'b11;
        #1;

        check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Bitwise OR (Zero result)", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        op = 2'b11;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
