`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inputValue;
    reg [4:0] shiftNum;
    wire [31:0] shifted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputValue(inputValue),
        .shiftNum(shiftNum),
        .shifted(shifted)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 0 (Identity)", test_num);
            inputValue = 32'h12345678;
            shiftNum = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 1", test_num);
            inputValue = 32'hA5A5A5A5;
            shiftNum = 5'd1;
            #1;

            check_outputs(32'h52D2D2D2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 2 (Stage 1)", test_num);
            inputValue = 32'hFFFFFFFF;
            shiftNum = 5'd2;
            #1;

            check_outputs(32'h3FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 4 (Stage 2)", test_num);
            inputValue = 32'hF0F0F0F0;
            shiftNum = 5'd4;
            #1;

            check_outputs(32'h0F0F0F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 8 (Stage 3)", test_num);
            inputValue = 32'h12345678;
            shiftNum = 5'd8;
            #1;

            check_outputs(32'h00123456);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 16 (Stage 4)", test_num);
            inputValue = 32'hDEADBEEF;
            shiftNum = 5'd16;
            #1;

            check_outputs(32'h0000DEAD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 31 (Maximum shift)", test_num);
            inputValue = 32'h80000000;
            shiftNum = 5'd31;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Zero", test_num);
            inputValue = 32'h00000000;
            shiftNum = 5'd15;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift All-Ones by 31", test_num);
            inputValue = 32'hFFFFFFFF;
            shiftNum = 5'd31;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift value that clears result", test_num);
            inputValue = 32'h00000001;
            shiftNum = 5'd1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern shift 7 (4+2+1 stages)", test_num);
            inputValue = 32'hABCDEF01;
            shiftNum = 5'd7;
            #1;

            check_outputs(32'h01579BDE);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift by 30", test_num);
            inputValue = 32'hC0000000;
            shiftNum = 5'd30;
            #1;

            check_outputs(32'h00000003);
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
        input [31:0] expected_shifted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted === (expected_shifted ^ shifted ^ expected_shifted)) begin
                $display("PASS");
                $display("  Outputs: shifted=%h",
                         shifted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted=%h",
                         expected_shifted);
                $display("  Got:      shifted=%h",
                         shifted);
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
