`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] S;
    reg z;
    wire [3:0] M;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .S(S),
        .z(z),
        .M(M)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select S when z=0 (S=5, A=A)", test_num);
            z = 1'b0;
            S = 4'h5;
            A = 4'hA;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A when z=1 (S=5, A=A)", test_num);
            z = 1'b1;
            S = 4'h5;
            A = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select S when z=0 (Boundary All Zeros)", test_num);
            z = 1'b0;
            S = 4'h0;
            A = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A when z=1 (Boundary All Zeros)", test_num);
            z = 1'b1;
            S = 4'hF;
            A = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select S when z=0 (Boundary All Ones)", test_num);
            z = 1'b0;
            S = 4'hF;
            A = 4'h0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A when z=1 (Boundary All Ones)", test_num);
            z = 1'b1;
            S = 4'h0;
            A = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data independence check (z=0, change A)", test_num);
            z = 1'b0;
            S = 4'h3;
            A = 4'hC;
            #1;
            A = 4'h5;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data independence check (z=1, change S)", test_num);
            z = 1'b1;
            S = 4'h3;
            A = 4'hC;
            #1;
            S = 4'h5;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern check", test_num);
            z = 1'b0;
            S = 4'b1010;
            A = 4'b0101;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern check", test_num);
            z = 1'b1;
            S = 4'b1010;
            A = 4'b0101;
            #1;

            check_outputs(4'b0101);
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
        input [3:0] expected_M;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M === (expected_M ^ M ^ expected_M)) begin
                $display("PASS");
                $display("  Outputs: M=%h",
                         M);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M=%h",
                         expected_M);
                $display("  Got:      M=%h",
                         M);
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
