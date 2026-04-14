`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] OP;
    wire [7:0] AND_out;
    wire [7:0] NOT_out;
    wire [7:0] OR_out;
    wire [7:0] XOR_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .AND_out(AND_out),
        .NOT_out(NOT_out),
        .OR_out(OR_out),
        .XOR_out(XOR_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=0 (AND), A=8'hFF, B=8'hAA", test_num);
            A = 8'hFF;
            B = 8'hAA;
            OP = 3'd0;

            #1;


            check_outputs(8'hAA, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=0 (AND), A=8'hF0, B=8'h0F", test_num);
            A = 8'hF0;
            B = 8'h0F;
            OP = 3'd0;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=1 (OR), A=8'hF0, B=8'h0F", test_num);
            A = 8'hF0;
            B = 8'h0F;
            OP = 3'd1;

            #1;


            check_outputs(8'h00, 8'h00, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=1 (OR), A=8'h55, B=8'h00", test_num);
            A = 8'h55;
            B = 8'h00;
            OP = 3'd1;

            #1;


            check_outputs(8'h00, 8'h00, 8'h55, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=2 (XOR), A=8'hAA, B=8'h55", test_num);
            A = 8'hAA;
            B = 8'h55;
            OP = 3'd2;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=2 (XOR), A=8'hF0, B=8'hCC", test_num);
            A = 8'hF0;
            B = 8'hCC;
            OP = 3'd2;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h3C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=3 (NOT), A=8'hA5", test_num);
            A = 8'hA5;
            B = 8'hFF;
            OP = 3'd3;

            #1;


            check_outputs(8'h00, 8'h5A, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=3 (NOT), A=8'h00", test_num);
            A = 8'h00;
            B = 8'hFF;
            OP = 3'd3;

            #1;


            check_outputs(8'h00, 8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=4 (Invalid Op)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            OP = 3'd4;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: OP=7 (Invalid Op)", test_num);
            A = 8'h12;
            B = 8'h34;
            OP = 3'd7;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_AND_out;
        input [7:0] expected_NOT_out;
        input [7:0] expected_OR_out;
        input [7:0] expected_XOR_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AND_out === (expected_AND_out ^ AND_out ^ expected_AND_out) &&
                expected_NOT_out === (expected_NOT_out ^ NOT_out ^ expected_NOT_out) &&
                expected_OR_out === (expected_OR_out ^ OR_out ^ expected_OR_out) &&
                expected_XOR_out === (expected_XOR_out ^ XOR_out ^ expected_XOR_out)) begin
                $display("PASS");
                $display("  Outputs: AND_out=%h, NOT_out=%h, OR_out=%h, XOR_out=%h",
                         AND_out, NOT_out, OR_out, XOR_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AND_out=%h, NOT_out=%h, OR_out=%h, XOR_out=%h",
                         expected_AND_out, expected_NOT_out, expected_OR_out, expected_XOR_out);
                $display("  Got:      AND_out=%h, NOT_out=%h, OR_out=%h, XOR_out=%h",
                         AND_out, NOT_out, OR_out, XOR_out);
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
