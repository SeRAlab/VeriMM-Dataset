`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i;
    wire [6:0] o0;
    wire o1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o0(o0),
        .o1(o1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            i = 8'h00;
            #1;

            check_outputs(7'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i = 8'hFF;
            #1;

            check_outputs(7'h7F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i = 8'h80;
            #1;

            check_outputs(7'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i = 8'h7F;
            #1;

            check_outputs(7'h7F, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i = 8'hAA;
            #1;

            check_outputs(7'h2A, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i = 8'h55;
            #1;

            check_outputs(7'h55, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i = 8'hF0;
            #1;

            check_outputs(7'h70, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            i = 8'h0F;
            #1;

            check_outputs(7'h0F, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            i = 8'hC3;
            #1;

            check_outputs(7'h43, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            i = 8'h12;
            #1;

            check_outputs(7'h12, 1'b0);
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
        input [6:0] expected_o0;
        input expected_o1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%b",
                         o0, o1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%b",
                         expected_o0, expected_o1);
                $display("  Got:      o0=%h, o1=%b",
                         o0, o1);
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
