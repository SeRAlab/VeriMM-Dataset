`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] OPCODE;
    reg RESET;
    wire [31:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OPCODE(OPCODE),
        .RESET(RESET),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: RESET Verification", test_num);
            RESET = 1;
            A = 32'h12345678;
            B = 32'h00001111;
            OPCODE = 2'b00;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (100 + 250)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd100;
            B = 32'd250;
            OPCODE = 2'b00;
            #10;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (500 - 150)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd500;
            B = 32'd150;
            OPCODE = 2'b01;
            #10;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction Negative Result (10 - 20)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd10;
            B = 32'd20;
            OPCODE = 2'b01;
            #10;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication (12 * 12)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd12;
            B = 32'd12;
            OPCODE = 2'b10;
            #10;
            #1;

            check_outputs(32'd144);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication by Zero", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'hABCDEF01;
            B = 32'd0;
            OPCODE = 2'b10;
            #10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division (1000 / 8)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd1000;
            B = 32'd8;
            OPCODE = 2'b11;
            #10;
            #1;

            check_outputs(32'd125);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division floor (5 / 10)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd5;
            B = 32'd10;
            OPCODE = 2'b11;
            #10;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition Overflow/Wrap", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            OPCODE = 2'b00;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Opcode change (Add then Multiply)", test_num);
            RESET = 1; #5; RESET = 0;
            A = 32'd10; B = 32'd5;
            OPCODE = 2'b00;
            #10;
            OPCODE = 2'b10;
            #10;
            #1;

            check_outputs(32'd50);
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
        input [31:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
