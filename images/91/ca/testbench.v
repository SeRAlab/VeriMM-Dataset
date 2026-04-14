`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A0;
    reg [3:0] A1;
    reg [3:0] A2;
    reg [3:0] A3;
    reg [1:0] M_select;
    wire [3:0] M_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .M_select(M_select),
        .M_out(M_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select A0 (M_select = 2'b00)", test_num);
            A0 = 4'hA; A1 = 4'h0; A2 = 4'h0; A3 = 4'h0;
            M_select = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select A1 (M_select = 2'b01)", test_num);
            A0 = 4'h0; A1 = 4'h5; A2 = 4'h0; A3 = 4'h0;
            M_select = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select A2 (M_select = 2'b10)", test_num);
            A0 = 4'h0; A1 = 4'h0; A2 = 4'hF; A3 = 4'h0;
            M_select = 2'b10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select A3 (M_select = 2'b11)", test_num);
            A0 = 4'h0; A1 = 4'h0; A2 = 4'h0; A3 = 4'h3;
            M_select = 2'b11;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Changing unselected inputs (Select A0)", test_num);
            A0 = 4'hC; A1 = 4'hF; A2 = 4'hF; A3 = 4'hF;
            M_select = 2'b00;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All inputs distinct, Select A2", test_num);
            A0 = 4'h1; A1 = 4'h2; A2 = 4'h4; A3 = 4'h8;
            M_select = 2'b10;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: All inputs same value, Select A1", test_num);
            A0 = 4'h7; A1 = 4'h7; A2 = 4'h7; A3 = 4'h7;
            M_select = 2'b01;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Zero inputs, Select A3", test_num);
            A0 = 4'h0; A1 = 4'h0; A2 = 4'h0; A3 = 4'h0;
            M_select = 2'b11;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_M_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M_out === (expected_M_out ^ M_out ^ expected_M_out)) begin
                $display("PASS");
                $display("  Outputs: M_out=%h",
                         M_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_out=%h",
                         expected_M_out);
                $display("  Got:      M_out=%h",
                         M_out);
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
