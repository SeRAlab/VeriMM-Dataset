`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg I4;
    reg I5;
    reg I6;
    reg I7;
    wire A;
    wire B;
    wire C;
    wire D;
    wire E;
    wire F;
    wire G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .I6(I6),
        .I7(I7),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G)
    );
    task set_input_bits;

        input [7:0] val;
        begin
            I0 = val[0]; I1 = val[1]; I2 = val[2]; I3 = val[3];
            I4 = val[4]; I5 = val[5]; I6 = val[6]; I7 = val[7];
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            set_input_bits(8'd0);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            set_input_bits(8'd1);
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            set_input_bits(8'd2);
            #1;

            check_outputs(0, 0, 1, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            set_input_bits(8'd3);
            #1;

            check_outputs(0, 0, 0, 0, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            set_input_bits(8'd4);
            #1;

            check_outputs(1, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            set_input_bits(8'd5);
            #1;

            check_outputs(0, 1, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            set_input_bits(8'd6);
            #1;

            check_outputs(0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            set_input_bits(8'd7);
            #1;

            check_outputs(0, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            set_input_bits(8'd8);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            set_input_bits(8'd9);
            #1;

            check_outputs(0, 0, 0, 0, 1, 0, 0);
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
        input expected_A;
        input expected_B;
        input expected_C;
        input expected_D;
        input expected_E;
        input expected_F;
        input expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D === (expected_D ^ D ^ expected_D) &&
                expected_E === (expected_E ^ E ^ expected_E) &&
                expected_F === (expected_F ^ F ^ expected_F) &&
                expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: A=%b, B=%b, C=%b, D=%b, E=%b, F=%b, G=%b",
                         A, B, C, D, E, F, G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, B=%b, C=%b, D=%b, E=%b, F=%b, G=%b",
                         expected_A, expected_B, expected_C, expected_D, expected_E, expected_F, expected_G);
                $display("  Got:      A=%b, B=%b, C=%b, D=%b, E=%b, F=%b, G=%b",
                         A, B, C, D, E, F, G);
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
