`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUop;
    reg [11:0] in0;
    reg [11:0] in1;
    wire CY;
    wire [11:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .in0(in0),
        .in1(in1),
        .CY(CY),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND operation - Zero result", test_num);
            ALUop = 2'b00;
            in0 = 12'hAAA;
            in1 = 12'h555;

            #1;


            check_outputs(1'b0, 12'h000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND operation - Non-zero result", test_num);
            ALUop = 2'b00;
            in0 = 12'hFFF;
            in1 = 12'h0F0;

            #1;


            check_outputs(1'b0, 12'h0F0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD operation - No carry", test_num);
            ALUop = 2'b01;
            in0 = 12'h123;
            in1 = 12'h456;

            #1;


            check_outputs(1'b0, 12'h579, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD operation - Carry and Zero result", test_num);
            ALUop = 2'b01;
            in0 = 12'hFFF;
            in1 = 12'h001;

            #1;


            check_outputs(1'b1, 12'h000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD operation - Carry and Non-zero result", test_num);
            ALUop = 2'b01;
            in0 = 12'h800;
            in1 = 12'h801;

            #1;


            check_outputs(1'b1, 12'h001, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND operation - All ones", test_num);
            ALUop = 2'b00;
            in0 = 12'hFFF;
            in1 = 12'hFFF;

            #1;


            check_outputs(1'b0, 12'hFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD operation - Zero inputs", test_num);
            ALUop = 2'b01;
            in0 = 12'h000;
            in1 = 12'h000;

            #1;


            check_outputs(1'b0, 12'h000, 1'b1);
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
        input expected_CY;
        input [11:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CY === (expected_CY ^ CY ^ expected_CY) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: CY=%b, out=%h, zero=%b",
                         CY, out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CY=%b, out=%h, zero=%b",
                         expected_CY, expected_out, expected_zero);
                $display("  Got:      CY=%b, out=%h, zero=%b",
                         CY, out, zero);
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
