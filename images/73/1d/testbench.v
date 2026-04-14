`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] op;
    reg [31:0] opA;
    reg [31:0] opB;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op(op),
        .opA(opA),
        .opB(opB),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise AND (Alternating bits)", test_num);
        opA = 32'hAAAAAAAA;
        opB = 32'h55555555;
        op = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise AND (Identity)", test_num);
        opA = 32'hFFFFFFFF;
        opB = 32'h12345678;
        op = 2'b00;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise OR (Alternating bits)", test_num);
        opA = 32'hAAAAAAAA;
        opB = 32'h55555555;
        op = 2'b01;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise OR (Zeros)", test_num);
        opA = 32'h00000000;
        opB = 32'hCAFEBABE;
        op = 2'b01;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise XOR (Self XOR)", test_num);
        opA = 32'hDEADBEEF;
        opB = 32'hDEADBEEF;
        op = 2'b10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise XOR (Pattern)", test_num);
        opA = 32'hF0F0F0F0;
        opB = 32'h0F0F0F0F;
        op = 2'b10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise NOR (Zeros)", test_num);
        opA = 32'h00000000;
        opB = 32'h00000000;
        op = 2'b11;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise NOR (Alternating)", test_num);
        opA = 32'hAAAAAAAA;
        opB = 32'h55555555;
        op = 2'b11;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: bitwise NOR (Specific Pattern)", test_num);
        opA = 32'h0000FFFF;
        opB = 32'h00FF00FF;
        op = 2'b11;

        #1;


        check_outputs(32'hFF000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Operation Switch Check", test_num);
        opA = 32'h11111111;
        opB = 32'h22222222;
        op = 2'b00;
        #2;
        op = 2'b10;

        #1;


        check_outputs(32'h33333333);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
