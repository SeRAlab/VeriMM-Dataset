`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_op;
    reg [63:0] i_wf_in;
    reg [31:0] i_wk;
    wire [63:0] o_wf_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_op(i_op),
        .i_wf_in(i_wf_in),
        .i_wk(i_wk),
        .o_wf_out(o_wf_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            i_op = 1'b0;
            i_wf_in = 64'h0;
            i_wk = 32'h0;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (Op 0)", test_num);
            i_op = 1'b0;
            i_wf_in = 64'hFFFFFFFFFFFFFFFF;
            i_wk = 32'hFFFFFFFF;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op 0 - XOR Pattern", test_num);
            i_op = 1'b0;
            i_wf_in = 64'hA5A5A5A55A5A5A5A;
            i_wk = 32'h12345678;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Op 1 - Addition Pattern", test_num);
            i_op = 1'b1;
            i_wf_in = 64'hA5A5A5A55A5A5A5A;
            i_wk = 32'h12345678;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Handling (Op 1)", test_num);
            i_op = 1'b1;
            i_wf_in = 64'hFFFFFFFFFFFFFFFF;
            i_wk = 32'h00000001;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            i_op = 1'b0;
            i_wf_in = 64'h55555555AAAAAAAA;
            i_wk = 32'hAAAAAAAA;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Ones (Data)", test_num);
            i_op = 1'b0;
            i_wf_in = 64'h0000000000000001;
            i_wk = 32'h0;
            repeat(64) begin
                #5;
                #1;

                check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
                i_wf_in = i_wf_in << 1;
            end
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Op Switching", test_num);
            i_wf_in = 64'hDEADBEEFCAFEBABE;
            i_wk = 32'h87654321;
            i_op = 1'b0; #5;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
            i_op = 1'b1; #5;
            #1;

            check_outputs(calculate_expected(i_op, i_wf_in, i_wk));
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
        input [63:0] expected_o_wf_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_wf_out === (expected_o_wf_out ^ o_wf_out ^ expected_o_wf_out)) begin
                $display("PASS");
                $display("  Outputs: o_wf_out=%h",
                         o_wf_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wf_out=%h",
                         expected_o_wf_out);
                $display("  Got:      o_wf_out=%h",
                         o_wf_out);
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
