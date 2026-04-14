`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] b;
    reg [8:0] deslocamento;
    reg [13:0] imediate;
    reg [1:0] op_b;
    reg [4:0] shift_desloc;
    wire [31:0] b_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .deslocamento(deslocamento),
        .imediate(imediate),
        .op_b(op_b),
        .shift_desloc(shift_desloc),
        .b_select(b_select)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select b (op_b=00)", test_num);
            b = 32'hA5A5_5A5A;
            deslocamento = 9'h0;
            imediate = 14'h0;
            shift_desloc = 5'h0;
            op_b = 2'b00;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select deslocamento (Positive) (op_b=01)", test_num);
            b = 32'h0;
            deslocamento = 9'h07F;
            imediate = 14'h0;
            shift_desloc = 5'h0;
            op_b = 2'b01;

            #1;


            check_outputs(32'h0000007F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select deslocamento (Negative) (op_b=01)", test_num);
            b = 32'h0;
            deslocamento = 9'h180;
            imediate = 14'h0;
            shift_desloc = 5'h0;
            op_b = 2'b01;

            #1;


            check_outputs(32'hFFFFF180);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select imediate (Positive) (op_b=10)", test_num);
            b = 32'h0;
            deslocamento = 9'h0;
            imediate = 14'h1FFF;
            shift_desloc = 5'h0;
            op_b = 2'b10;

            #1;


            check_outputs(32'h00001FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select imediate (Negative) (op_b=10)", test_num);
            b = 32'h0;
            deslocamento = 9'h0;
            imediate = 14'h2001;
            shift_desloc = 5'h0;
            op_b = 2'b10;

            #1;


            check_outputs(32'hFFFFE001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select shift_desloc (op_b=11)", test_num);
            b = 32'hFFFF_FFFF;
            deslocamento = 9'h1FF;
            imediate = 14'h3FFF;
            shift_desloc = 5'h1A;
            op_b = 2'b11;

            #1;


            check_outputs(32'h0000001A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select b (Alternative Value) (op_b=00)", test_num);
            b = 32'h1234_5678;
            deslocamento = 9'h0;
            imediate = 14'h0;
            shift_desloc = 5'h0;
            op_b = 2'b00;
            #1;

            check_outputs(32'h1234_5678);
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
        input [31:0] expected_b_select;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_select === (expected_b_select ^ b_select ^ expected_b_select)) begin
                $display("PASS");
                $display("  Outputs: b_select=%h",
                         b_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_select=%h",
                         expected_b_select);
                $display("  Got:      b_select=%h",
                         b_select);
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
