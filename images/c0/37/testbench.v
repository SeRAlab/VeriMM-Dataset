`timescale 1ns/1ps

module alu_adder_tb;

    // Testbench signals (combinational circuit)
    reg ORsel;
    reg XORsel;
    reg carry_in;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] and_result;
    wire [8:0] carry_out;
    wire [7:0] or_result;
    wire [7:0] xor_result;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_adder dut (
        .ORsel(ORsel),
        .XORsel(XORsel),
        .carry_in(carry_in),
        .x(x),
        .y(y),
        .and_result(and_result),
        .carry_out(carry_out),
        .or_result(or_result),
        .xor_result(xor_result),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Basic Addition (5 + 3)", test_num);
            x = 8'h05; y = 8'h03; carry_in = 0; ORsel = 0; XORsel = 1;


            #1;



            check_outputs(8'h01, 9'h00E, 8'h07, 8'h06, 8'h08);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Bitwise Logic (0xAA, 0x55)", test_num);
            x = 8'hAA; y = 8'h55; carry_in = 0; ORsel = 0; XORsel = 0;


            #1;



            check_outputs(8'h00, 9'h000, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Carry Propagation (0xFF + 1)", test_num);
            x = 8'hFF; y = 8'h01; carry_in = 0; ORsel = 0; XORsel = 1;


            #1;



            check_outputs(8'h01, 9'h1FF, 8'hFF, 8'hFE, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: XORsel Disabled (Logic Mode)", test_num);
            x = 8'h0F; y = 8'h0F; carry_in = 1; ORsel = 0; XORsel = 0;

            #1;


            check_outputs(8'h0F, 9'h01F, 8'h0F, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: ORsel Carry Influence", test_num);
            x = 8'h01; y = 8'h01; carry_in = 1; ORsel = 1; XORsel = 1;



            #1;




            check_outputs(8'h01, 9'h003, 8'h01, 8'h00, 8'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Ones", test_num);
            x = 8'hFF; y = 8'hFF; carry_in = 1; ORsel = 0; XORsel = 1;


            #1;



            check_outputs(8'hFF, 9'h1FF, 8'hFF, 8'h00, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros", test_num);
            x = 8'h00; y = 8'h00; carry_in = 0; ORsel = 0; XORsel = 1;
            #1;

            check_outputs(8'h00, 9'h000, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Carry In Only", test_num);
            x = 8'h00; y = 8'h00; carry_in = 1; ORsel = 0; XORsel = 1;

            #1;


            check_outputs(8'h00, 9'h001, 8'h00, 8'h00, 8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_adder Testbench");
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
        input [7:0] expected_and_result;
        input [8:0] expected_carry_out;
        input [7:0] expected_or_result;
        input [7:0] expected_xor_result;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_or_result === (expected_or_result ^ or_result ^ expected_or_result) &&
                expected_xor_result === (expected_xor_result ^ xor_result ^ expected_xor_result) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h, carry_out=%h, or_result=%h, xor_result=%h, z=%h",
                         and_result, carry_out, or_result, xor_result, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h, carry_out=%h, or_result=%h, xor_result=%h, z=%h",
                         expected_and_result, expected_carry_out, expected_or_result, expected_xor_result, expected_z);
                $display("  Got:      and_result=%h, carry_out=%h, or_result=%h, xor_result=%h, z=%h",
                         and_result, carry_out, or_result, xor_result, z);
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
