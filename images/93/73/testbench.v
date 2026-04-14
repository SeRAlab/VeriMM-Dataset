`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [2:0] aluop;
    reg [31:0] b;
    wire bge_flag;
    wire oflow;
    wire [31:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluop(aluop),
        .b(b),
        .bge_flag(bge_flag),
        .oflow(oflow),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;



            aluop = 3'b000; a = 32'd10; b = 32'd20;
            #1;

            check_outputs(1'b1, 1'b0, 32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;



            aluop = 3'b000; a = 32'h7FFFFFFF; b = 32'd1;
            #1;

            check_outputs(1'b0, 1'b1, 32'h80000000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;



            aluop = 3'b001; a = 32'hAAAA5555; b = 32'h5555AAAA;
            #1;

            check_outputs(1'b1, 1'b0, 32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;


            aluop = 3'b010; a = 32'd5; b = 32'd10;
            #1;

            check_outputs(1'b1, 1'b0, 32'd1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;


            aluop = 3'b010; a = 32'd20; b = 32'd10;
            #1;

            check_outputs(1'b1, 1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;


            aluop = 3'b011; a = 32'd100; b = 32'd40;
            #1;

            check_outputs(1'b1, 1'b0, 32'd60, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;



            aluop = 3'b011; a = 32'h80000000; b = 32'd1;
            #1;

            check_outputs(1'b1, 1'b1, 32'h7FFFFFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;


            aluop = 3'b100; a = 32'h80000000; b = 32'd1;
            #1;

            check_outputs(1'b1, 1'b0, 32'h40000000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;


            aluop = 3'b011; a = 32'd50; b = 32'd50;
            #1;

            check_outputs(1'b1, 1'b0, 32'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;


            aluop = 3'b000; a = 32'd268435456; b = 32'd0;
            #1;

            check_outputs(1'b0, 1'b0, 32'h10000000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;


            aluop = 3'b000; a = 32'd268435455; b = 32'd0;
            #1;

            check_outputs(1'b1, 1'b0, 32'h0FFFFFFF, 1'b0);
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
        input expected_bge_flag;
        input expected_oflow;
        input [31:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bge_flag === (expected_bge_flag ^ bge_flag ^ expected_bge_flag) &&
                expected_oflow === (expected_oflow ^ oflow ^ expected_oflow) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: bge_flag=%b, oflow=%b, out=%h, zero=%b",
                         bge_flag, oflow, out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bge_flag=%b, oflow=%b, out=%h, zero=%b",
                         expected_bge_flag, expected_oflow, expected_out, expected_zero);
                $display("  Got:      bge_flag=%b, oflow=%b, out=%h, zero=%b",
                         bge_flag, oflow, out, zero);
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
