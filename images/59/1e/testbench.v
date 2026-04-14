`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] operation_select;
    reg [4:0] shift_amount;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .operation_select(operation_select),
        .shift_amount(shift_amount),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Logical AND (op=00)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'hFFFF_0000;
            operation_select = 2'b00;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hAAAA_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Logical AND with Zero (op=00)", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0000;
            operation_select = 2'b00;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Logical OR (op=01)", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            operation_select = 2'b01;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h9775_5779);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Logical OR with All Ones (op=01)", test_num);
            a = 32'h0000_0000;
            b = 32'hFFFF_FFFF;
            operation_select = 2'b01;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Logical XOR (op=10)", test_num);
            a = 32'hF0F0_F0F0;
            b = 32'hCCCC_CCCC;
            operation_select = 2'b10;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h3C3C_3C3C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Logical XOR Self (op=10)", test_num);
            a = 32'hABCD_1234;
            b = 32'hABCD_1234;
            operation_select = 2'b10;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Left Shift by 1 (op=11)", test_num);
            a = 32'h0000_0001;
            b = 32'h0000_0000;
            operation_select = 2'b11;
            shift_amount = 5'd1;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Left Shift by 8 (op=11)", test_num);
            a = 32'h0000_00FF;
            b = 32'h0000_0000;
            operation_select = 2'b11;
            shift_amount = 5'd8;
            #1;

            check_outputs(32'h0000_FF00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Left Shift by 31 (op=11)", test_num);
            a = 32'h0000_0001;
            b = 32'h0000_0000;
            operation_select = 2'b11;
            shift_amount = 5'd31;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Left Shift by 0 (op=11)", test_num);
            a = 32'hDEAD_BEEF;
            b = 32'h0000_0000;
            operation_select = 2'b11;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: Mixed Logic and Shift Check", test_num);
            a = 32'h0000_FFFF;
            b = 32'hFFFF_0000;

            operation_select = 2'b00;
            #1;

            check_outputs(32'h0000_0000);


            operation_select = 2'b01;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
