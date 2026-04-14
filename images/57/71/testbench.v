`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg carry_in;
    wire [31:0] amul2;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .carry_in(carry_in),
        .amul2(amul2),
        .carry_out(carry_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 32'h00000000;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h00000000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones with carry_in=1", test_num);
            a = 32'hFFFFFFFF;
            carry_in = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift out MSB 1", test_num);
            a = 32'h80000000;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift in carry_in=1", test_num);
            a = 32'h00000001;
            carry_in = 1'b1;
            #1;

            check_outputs(32'h00000003, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern A", test_num);
            a = 32'hAAAAAAAA;
            carry_in = 1'b1;


            #1;



            check_outputs(32'h55555555, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern 5", test_num);
            a = 32'h55555555;
            carry_in = 1'b0;


            #1;



            check_outputs(32'hAAAAAAAA, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Check - 0x7FFFFFFF", test_num);
            a = 32'h7FFFFFFF;
            carry_in = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed bits shift", test_num);
            a = 32'hC0000003;
            carry_in = 1'b0;


            #1;



            check_outputs(32'h80000006, 1'b1);
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
        input [31:0] expected_amul2;
        input expected_carry_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_amul2 === (expected_amul2 ^ amul2 ^ expected_amul2) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: amul2=%h, carry_out=%b",
                         amul2, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: amul2=%h, carry_out=%b",
                         expected_amul2, expected_carry_out);
                $display("  Got:      amul2=%h, carry_out=%b",
                         amul2, carry_out);
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
