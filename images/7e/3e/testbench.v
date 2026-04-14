`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] E;
    reg [7:0] F;
    reg [7:0] G;
    reg [7:0] H;
    wire [7:0] Y;

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
        .F(F),
        .G(G),
        .H(H),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd0;
            E = 8'd0; F = 8'd0; G = 8'd0; H = 8'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple mixed operations", test_num);
            A = 8'd10; B = 8'd20;
            C = 8'd5;  D = 8'd5;
            E = 8'd15; F = 8'd5;
            G = 8'd5;  H = 8'd5;

            #1;


            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result resulting in underflow", test_num);
            A = 8'd5;  B = 8'd5;
            C = 8'd20; D = 8'd20;
            E = 8'd5;  F = 8'd5;
            G = 8'd5;  H = 8'd5;


            #1;



            check_outputs(8'd226);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large intermediate values", test_num);
            A = 8'd200; B = 8'd100;
            C = 8'd50;  D = 8'd50;
            E = 8'd150; F = 8'd150;
            G = 8'd25;  H = 8'd25;







            #1;








            check_outputs(8'd194);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs at max (0xFF)", test_num);
            A = 8'hFF; B = 8'hFF; C = 8'hFF; D = 8'hFF;
            E = 8'hFF; F = 8'hFF; G = 8'hFF; H = 8'hFF;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Balanced result", test_num);
            A = 8'd100; B = 8'd50;
            C = 8'd75;  D = 8'd75;
            E = 8'd40;  F = 8'd60;
            G = 8'd30;  H = 8'd70;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single active input", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd128;
            E = 8'd0; F = 8'd0; G = 8'd0; H = 8'd0;


            #1;



            check_outputs(8'd128);
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
        input [7:0] expected_Y;
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
