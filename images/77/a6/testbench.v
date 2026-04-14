`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [1:0] B;
    reg C;
    reg D;
    reg E;
    reg F;
    reg G;
    reg H;
    reg I;
    wire J;

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
        .I(I),
        .J(J)
    );
    task reset_inputs;

        begin
            A = 3'b000;
            B = 2'b00;
            C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; I = 0;
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=111 Priority High", test_num);
            reset_inputs();
            A = 3'b111;
            B = 2'b11;
            C = 0; D = 1; E = 0; F = 1; G = 0; H = 1; I = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=000 Priority Low", test_num);
            reset_inputs();
            A = 3'b000;

            B = 2'b00; C = 1; D = 0; E = 1; F = 0; G = 1; H = 0; I = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=001, Condition Met", test_num);
            reset_inputs();
            A = 3'b001;
            B = 2'b00; C = 1; D = 0; E = 1; F = 0; G = 1; H = 0; I = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=010, Condition Fails (B)", test_num);
            reset_inputs();
            A = 3'b010;
            B = 2'b01;
            C = 1; D = 0; E = 1; F = 0; G = 1; H = 0; I = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=011, Condition Fails (C)", test_num);
            reset_inputs();
            A = 3'b011;
            B = 2'b00;
            C = 0;
            D = 0; E = 1; F = 0; G = 1; H = 0; I = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=100, Condition Fails (D)", test_num);
            reset_inputs();
            A = 3'b100;
            B = 2'b00; C = 1;
            D = 1;
            E = 1; F = 0; G = 1; H = 0; I = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=101, Condition Fails (I)", test_num);
            reset_inputs();
            A = 3'b101;
            B = 2'b00; C = 1; D = 0; E = 1; F = 0; G = 1; H = 0;
            I = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=110, Condition Met", test_num);
            reset_inputs();
            A = 3'b110;
            B = 2'b00; C = 1; D = 0; E = 1; F = 0; G = 1; H = 0; I = 1;
            #1;

            check_outputs(1'b1);
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
        input expected_J;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_J === (expected_J ^ J ^ expected_J)) begin
                $display("PASS");
                $display("  Outputs: J=%b",
                         J);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: J=%b",
                         expected_J);
                $display("  Got:      J=%b",
                         J);
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
