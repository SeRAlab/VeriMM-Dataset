`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] exp_a;
    reg [7:0] exp_b;
    reg sel_c;
    wire [7:0] exp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exp_a(exp_a),
        .exp_b(exp_b),
        .sel_c(sel_c),
        .exp_out(exp_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Select exp_a (sel_c=0)", test_num);
            exp_a = 8'hA5;
            exp_b = 8'h5A;
            sel_c = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Select exp_b (sel_c=1)", test_num);
            exp_a = 8'hA5;
            exp_b = 8'h5A;
            sel_c = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All ones on exp_a, All zeros on exp_b (sel_c=0)", test_num);
            exp_a = 8'hFF;
            exp_b = 8'h00;
            sel_c = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All ones on exp_a, All zeros on exp_b (sel_c=1)", test_num);
            exp_a = 8'hFF;
            exp_b = 8'h00;
            sel_c = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Walking pattern on exp_a (sel_c=0)", test_num);
            exp_a = 8'h12;
            exp_b = 8'h34;
            sel_c = 1'b0;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Walking pattern on exp_b (sel_c=1)", test_num);
            exp_a = 8'h12;
            exp_b = 8'h34;
            sel_c = 1'b1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Nibble check (sel_c=1)", test_num);
            exp_a = 8'hF0;
            exp_b = 8'h0F;
            sel_c = 1'b1;
            #1;

            check_outputs(8'h0F);
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
        input [7:0] expected_exp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exp_out === (expected_exp_out ^ exp_out ^ expected_exp_out)) begin
                $display("PASS");
                $display("  Outputs: exp_out=%h",
                         exp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exp_out=%h",
                         expected_exp_out);
                $display("  Got:      exp_out=%h",
                         exp_out);
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
