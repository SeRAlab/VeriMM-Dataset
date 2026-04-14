`timescale 1ns/1ps

module alu_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg opcode;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'h0005; B = 16'h0003; opcode = 0;
        $display("Test %0d: Addition - Basic (5 + 3)", test_num);
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h000A; B = 16'h0004; opcode = 1;
        $display("Test %0d: Subtraction - Basic (10 - 4)", test_num);
        #1;

        check_outputs(16'h0006);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'h1234; B = 16'h0000; opcode = 0;
        $display("Test %0d: Addition - Zero Identity", test_num);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'hFFFF; B = 16'hFFFF; opcode = 1;
        $display("Test %0d: Subtraction - Result Zero", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'hFFFF; B = 16'h0001; opcode = 0;
        $display("Test %0d: Addition - Overflow/Wrap-around", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'h0000; B = 16'h0001; opcode = 1;
        $display("Test %0d: Subtraction - Underflow (Negative)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'h7000; B = 16'h1000; opcode = 0;
        $display("Test %0d: Addition - Large numbers", test_num);
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'h8000; B = 16'h0001; opcode = 1;
        $display("Test %0d: Subtraction - Boundary", test_num);
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu Testbench");
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
        input [15:0] expected_result;
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
