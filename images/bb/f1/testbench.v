`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] G2;
    reg [31:0] Pr2;
    wire [31:0] G3;
    wire [31:0] Pr3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G2(G2),
        .Pr2(Pr2),
        .G3(G3),
        .Pr3(Pr3)
    );
    task calculate_expected;

        input [31:0] i_G2;
        input [31:0] i_Pr2;
        output [31:0] o_G3;
        output [31:0] o_Pr3;
        integer i;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                if (i >= 4) begin
                    o_G3[i] = i_G2[i] | (i_Pr2[i] & i_G2[i-4]);
                    o_Pr3[i] = i_Pr2[i] & i_Pr2[i-4];
                end else begin
                    o_G3[i] = i_G2[i];
                    o_Pr3[i] = i_Pr2[i];
                end
            end
        end
        endtask

    task testcase001;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            G2 = 32'h00000000;
            Pr2 = 32'h00000000;
            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
        end
        endtask

    task testcase002;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            G2 = 32'hFFFFFFFF;
            Pr2 = 32'hFFFFFFFF;
            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
        end
        endtask

    task testcase003;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagate Only (Check Pr3 distance 4)", test_num);
            G2 = 32'h00000000;
            Pr2 = 32'hAAAAAAAA;
            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
        end
        endtask

    task testcase004;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Generate Propagation (G2[0] propagates to G3[4])", test_num);
            G2 = 32'h0000000F;
            Pr2 = 32'h000000F0;
            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
        end
        endtask

    task testcase005;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            G2 = 32'h55555555;
            Pr2 = 32'h33333333;
            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
        end
        endtask

    task testcase006;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Data Pattern", test_num);
            G2 = 32'hA5A5A5A5;
            Pr2 = 32'hF0F0F0F0;
            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
        end
        endtask

    task testcase007;

        reg [31:0] exp_G;
        reg [31:0] exp_P;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check (MSB)", test_num);
            G2 = 32'h08000000;
            Pr2 = 32'h80000000;

            calculate_expected(G2, Pr2, exp_G, exp_P);
            #1;

            check_outputs(exp_G, exp_P);
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
        input [31:0] expected_G3;
        input [31:0] expected_Pr3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G3 === (expected_G3 ^ G3 ^ expected_G3) &&
                expected_Pr3 === (expected_Pr3 ^ Pr3 ^ expected_Pr3)) begin
                $display("PASS");
                $display("  Outputs: G3=%h, Pr3=%h",
                         G3, Pr3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G3=%h, Pr3=%h",
                         expected_G3, expected_Pr3);
                $display("  Got:      G3=%h, Pr3=%h",
                         G3, Pr3);
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
