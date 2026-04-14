`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg C;
    reg [3:0] S;
    wire [15:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .C(C),
        .S(S),
        .B(B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Left Shift by 0", test_num);
            A = 16'hABCD;
            S = 4'd0;
            C = 1'b0;
            #10;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Left Shift by 1", test_num);
            A = 16'hFFFF;
            S = 4'd1;
            C = 1'b0;
            #10;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Left Shift by 4", test_num);
            A = 16'h1234;
            S = 4'd4;
            C = 1'b0;
            #10;
            #1;

            check_outputs(16'h2340);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Left Shift by 12", test_num);
            A = 16'h000F;
            S = 4'd12;
            C = 1'b0;
            #10;
            #1;

            check_outputs(16'hF000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Left Shift by 15", test_num);
            A = 16'hFFFF;
            S = 4'd15;
            C = 1'b0;
            #10;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift by 0", test_num);
            A = 16'hABCD;
            S = 4'd0;
            C = 1'b1;
            #10;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift by 1", test_num);
            A = 16'hFFFF;
            S = 4'd1;
            C = 1'b1;
            #10;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift by 4", test_num);
            A = 16'h1234;
            S = 4'd4;
            C = 1'b1;
            #10;
            #1;

            check_outputs(16'h0123);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift by 12", test_num);
            A = 16'hF000;
            S = 4'd12;
            C = 1'b1;
            #10;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift by 15", test_num);
            A = 16'hFFFF;
            S = 4'd15;
            C = 1'b1;
            #10;
            #1;

            check_outputs(16'h0001);
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
        input [15:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
