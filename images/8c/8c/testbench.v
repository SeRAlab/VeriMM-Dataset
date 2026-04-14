`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition 3 + 5", test_num);
            A = 4'd3;
            B = 4'd5;
            C = 1'b0;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition 12 + 6 (Overflow)", test_num);
            A = 4'd12;
            B = 4'd6;
            C = 1'b0;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition 7 + 0", test_num);
            A = 4'd7;
            B = 4'd0;
            C = 1'b0;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction 10 - 4", test_num);
            A = 4'd10;
            B = 4'd4;
            C = 1'b1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction 3 - 7 (Negative result)", test_num);
            A = 4'd3;
            B = 4'd7;
            C = 1'b1;

            #1;


            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction 8 - 8", test_num);
            A = 4'd8;
            B = 4'd8;
            C = 1'b1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction 0 - 1", test_num);
            A = 4'd0;
            B = 4'd1;
            C = 1'b1;

            #1;


            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition 15 + 15", test_num);
            A = 4'hF;
            B = 4'hF;
            C = 1'b0;

            #1;


            check_outputs(4'hE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction 15 - 15", test_num);
            A = 4'hF;
            B = 4'hF;
            C = 1'b1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Subtraction 15 - 0", test_num);
            A = 4'd15;
            B = 4'd0;
            C = 1'b1;
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
