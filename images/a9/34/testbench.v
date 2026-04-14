`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg op;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd2;
            B = 4'd3;
            op = 1'b0;
            #10;
            $display("Testcase %0d: Addition 2 + 3", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd4;
            B = 4'd4;
            op = 1'b0;
            #10;
            $display("Testcase %0d: Addition 4 + 4 = 8 (MSB=1)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd1;
            op = 1'b0;
            #10;
            $display("Testcase %0d: Addition 15 + 1 (Overflow)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd4;
            op = 1'b1;
            #10;
            $display("Testcase %0d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd4;
            B = 4'd10;
            op = 1'b1;
            #10;
            $display("Testcase %0d: Subtraction 4 - 10 = -6", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd1;
            op = 1'b1;
            #10;
            $display("Testcase %0d: Subtraction 0 - 1 = -1", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            op = 1'b1;
            #10;
            $display("Testcase %0d: Subtraction 8 - 8 = 0", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            op = 1'b0;
            #10;
            $display("Testcase %0d: Addition 15 + 15", test_num);
            #1;

            check_outputs(4'b1110);
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
