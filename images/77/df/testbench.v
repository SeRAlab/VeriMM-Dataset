`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input1;
    reg [7:0] input2;
    reg [7:0] input3;
    reg [7:0] input4;
    reg sel_b1;
    reg sel_b2;
    wire [7:0] out_always;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_always(out_always)
    );
    task testcase001;

        begin
            test_num = 1;
            input1 = 8'hAA; input2 = 8'hBB; input3 = 8'hCC; input4 = 8'hDD;
            sel_b1 = 1'b0; sel_b2 = 1'b0;
            #10;
            $display("Test Case 001: Select input1 (00)");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input1 = 8'h11; input2 = 8'h22; input3 = 8'h33; input4 = 8'h44;
            sel_b1 = 1'b0; sel_b2 = 1'b1;
            #10;
            $display("Test Case 002: Select input2 (01)");
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input1 = 8'h0F; input2 = 8'hF0; input3 = 8'h55; input4 = 8'hAA;
            sel_b1 = 1'b1; sel_b2 = 1'b0;
            #10;
            $display("Test Case 003: Select input3 (10)");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input1 = 8'hDE; input2 = 8'hAD; input3 = 8'hBE; input4 = 8'hEF;
            sel_b1 = 1'b1; sel_b2 = 1'b1;
            #10;
            $display("Test Case 004: Select input4 (11)");
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input1 = 8'h00; input2 = 8'h00; input3 = 8'h00; input4 = 8'h00;
            sel_b1 = 1'b0; sel_b2 = 1'b0;
            #10;
            $display("Test Case 005: All inputs zero, select input1");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input1 = 8'hFF; input2 = 8'hFF; input3 = 8'hFF; input4 = 8'hFF;
            sel_b1 = 1'b1; sel_b2 = 1'b1;
            #10;
            $display("Test Case 006: All inputs 0xFF, select input4");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input1 = 8'h12; input2 = 8'h34; input3 = 8'h56; input4 = 8'h78;
            sel_b1 = 1'b0; sel_b2 = 1'b1;
            #5;
            input2 = 8'h99;
            #5;
            $display("Test Case 007: Verify output updates when selected input changes");
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_out_always;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always)) begin
                $display("PASS");
                $display("  Outputs: out_always=%h",
                         out_always);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%h",
                         expected_out_always);
                $display("  Got:      out_always=%h",
                         out_always);
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
