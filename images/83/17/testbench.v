`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A_i;
    reg [7:0] B_i;
    reg S_i;
    wire [7:0] Y_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_i(A_i),
        .B_i(B_i),
        .S_i(S_i),
        .Y_o(Y_o)
    );
    task testcase001;

        begin
            test_num = 1;
            A_i = 8'hA5;
            B_i = 8'h5A;
            S_i = 1'b0;
            $display("Test %0d: Select A_i when S_i=0", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A_i = 8'hA5;
            B_i = 8'h5A;
            S_i = 1'b1;
            $display("Test %0d: Select B_i when S_i=1", test_num);
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A_i = 8'hFF;
            B_i = 8'h00;
            S_i = 1'b0;
            $display("Test %0d: Select A_i (All High) when S_i=0", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A_i = 8'hFF;
            B_i = 8'h00;
            S_i = 1'b1;
            $display("Test %0d: Select B_i (All Low) when S_i=1", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A_i = 8'h12;
            B_i = 8'h34;
            S_i = 1'b0;
            $display("Test %0d: Select A_i (Arbitrary) when S_i=0", test_num);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A_i = 8'h12;
            B_i = 8'h34;
            S_i = 1'b1;
            $display("Test %0d: Select B_i (Arbitrary) when S_i=1", test_num);
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A_i = 8'h80;
            B_i = 8'h01;
            S_i = 1'b0;
            $display("Test %0d: Edge case values when S_i=0", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A_i = 8'h80;
            B_i = 8'h01;
            S_i = 1'b1;
            $display("Test %0d: Edge case values when S_i=1", test_num);
            #1;

            check_outputs(8'h01);
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
        input [7:0] expected_Y_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y_o === (expected_Y_o ^ Y_o ^ expected_Y_o)) begin
                $display("PASS");
                $display("  Outputs: Y_o=%h",
                         Y_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y_o=%h",
                         expected_Y_o);
                $display("  Got:      Y_o=%h",
                         Y_o);
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
