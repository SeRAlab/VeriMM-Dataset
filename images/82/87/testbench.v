`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S0;
    reg [1:0] S1;
    wire [3:0] Y;

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
        .S0(S0),
        .S1(S1),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting Input A (S1=0, S0=0)", test_num);
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hC;
            S1 = 0; S0 = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting Input B (S1=0, S0=1)", test_num);
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hC;
            S1 = 0; S0 = 1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting Input C (S1=1, S0=0)", test_num);
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hC;
            S1 = 1; S0 = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Selecting Input D (S1=1, S0=1)", test_num);
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hC;
            S1 = 1; S0 = 1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Changing selected input A dynamically", test_num);
            S1 = 0; S0 = 0;
            A = 4'h1; B = 4'hF; C = 4'hF; D = 4'hF;
            #1;
            A = 4'hE;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero, select B", test_num);
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            S1 = 0; S0 = 1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs 0xF, select D", test_num);
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            S1 = 1; S0 = 1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Switching select from C to A", test_num);
            A = 4'h2; B = 4'h4; C = 4'h8; D = 4'h1;
            S1 = 1; S0 = 0;
            #1;
            S1 = 0; S0 = 0;
            #1;

            check_outputs(4'h2);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
