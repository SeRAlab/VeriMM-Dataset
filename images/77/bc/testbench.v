`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] Opcode;
    wire C;
    wire V;
    wire [3:0] arith_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .C(C),
        .V(V),
        .arith_out(arith_out)
    );
    task set_inputs;

        input [3:0] i_A;
        input [3:0] i_B;
        input [1:0] i_Op;
        begin
            A = i_A;
            B = i_B;
            Opcode = i_Op;
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=%h, B=%h, Opcode=%b", test_num, A, B, Opcode);
        end
        endtask

    task testcase001;

        begin
            set_inputs(4'h3, 4'h2, 2'b00);
            #1;

            check_outputs(1'b0, 1'b0, 4'h5);
        end
        endtask

    task testcase002;

        begin
            set_inputs(4'hF, 4'h1, 2'b00);
            #1;

            check_outputs(1'b1, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            set_inputs(4'h2, 4'h7, 2'b00);
            #1;

            check_outputs(1'b0, 1'b1, 4'h9);
        end
        endtask

    task testcase004;

        begin
            set_inputs(4'h5, 4'h0, 2'b01);

            #1;


            check_outputs(C, 1'b0, 4'h6);
        end
        endtask

    task testcase005;

        begin
            set_inputs(4'hF, 4'hA, 2'b01);
            #1;

            check_outputs(C, 1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            set_inputs(4'hA, 4'h4, 2'b10);
            #1;

            check_outputs(1'b0, 1'b0, 4'h6);
        end
        endtask

    task testcase007;

        begin
            set_inputs(4'h4, 4'hA, 2'b10);
            #1;

            check_outputs(1'b1, 1'b1, 4'hA);
        end
        endtask

    task testcase008;

        begin
            set_inputs(4'h8, 4'h8, 2'b10);
            #1;

            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase009;

        begin
            set_inputs(4'h8, 4'hF, 2'b11);
            #1;

            check_outputs(C, 1'b1, 4'h7);
        end
        endtask

    task testcase010;

        begin
            set_inputs(4'h0, 4'h1, 2'b11);
            #1;

            check_outputs(C, 1'b1, 4'hF);
        end
        endtask

    task testcase011;

        begin
            set_inputs(4'h7, 4'h8, 2'b00);
            #1;

            check_outputs(1'b0, 1'b1, 4'hF);
        end
        endtask

    task testcase012;

        begin
            set_inputs(4'hE, 4'hE, 2'b00);
            #1;

            check_outputs(1'b1, 1'b0, 4'hC);
        end
        endtask

    task testcase013;

        begin
            set_inputs(4'h0, 4'hF, 2'b10);
            #1;

            check_outputs(1'b1, 1'b1, 4'h1);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_C;
        input expected_V;
        input [3:0] expected_arith_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_arith_out === (expected_arith_out ^ arith_out ^ expected_arith_out)) begin
                $display("PASS");
                $display("  Outputs: C=%b, V=%b, arith_out=%h",
                         C, V, arith_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, V=%b, arith_out=%h",
                         expected_C, expected_V, expected_arith_out);
                $display("  Got:      C=%b, V=%b, arith_out=%h",
                         C, V, arith_out);
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
