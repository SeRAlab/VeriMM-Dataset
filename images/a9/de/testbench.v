`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg E;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: E=1, Selecting A", test_num);
            A = 4'h5;
            B = 4'h0;
            C = 4'h0;
            D = 4'hA;
            E = 1'b1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: E=0, Selecting D", test_num);
            A = 4'h5;
            B = 4'h0;
            C = 4'h0;
            D = 4'hA;
            E = 1'b0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify B/C have no effect when E=1", test_num);
            A = 4'hF;
            B = 4'h7;
            C = 4'h3;
            D = 4'h0;
            E = 1'b1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify B/C have no effect when E=0", test_num);
            A = 4'h0;
            B = 4'hF;
            C = 4'hE;
            D = 4'h2;
            E = 1'b0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs same, E=1", test_num);
            A = 4'h8;
            B = 4'h8;
            C = 4'h8;
            D = 4'h8;
            E = 1'b1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs same, E=0", test_num);
            A = 4'h3;
            B = 4'h3;
            C = 4'h3;
            D = 4'h3;
            E = 1'b0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switching E with dynamic inputs", test_num);
            A = 4'hC;
            D = 4'h3;
            E = 1'b1;
            #5;
            E = 1'b0;
            #1;

            check_outputs(4'h3);
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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
