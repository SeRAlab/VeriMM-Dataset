`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A_hex;
    reg [7:0] B_hex;
    wire [7:0] A_dec;
    wire [7:0] B_dec;
    wire [15:0] OP_dec;
    wire [15:0] OP_hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_hex(A_hex),
        .B_hex(B_hex),
        .A_dec(A_dec),
        .B_dec(B_dec),
        .OP_dec(OP_dec),
        .OP_hex(OP_hex)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=0", test_num);
            A_hex = 8'd0;
            B_hex = 8'd0;
            #1;

            check_outputs(8'h00, 8'h00, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=7, B=8 (Single Digits)", test_num);
            A_hex = 8'd7;
            B_hex = 8'd8;

            #1;


            check_outputs(8'h07, 8'h08, 16'h0056, 16'h0038);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=12, B=10 (Power of 10 boundary)", test_num);
            A_hex = 8'd12;
            B_hex = 8'd10;

            #1;


            check_outputs(8'h12, 8'h10, 16'h0120, 16'h0078);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=25, B=40 (Result is 1000)", test_num);
            A_hex = 8'd25;
            B_hex = 8'd40;

            #1;


            check_outputs(8'h25, 8'h40, 16'h1000, 16'h03E8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=99, B=99 (Max 2-digit BCD inputs)", test_num);
            A_hex = 8'd99;
            B_hex = 8'd99;

            #1;


            check_outputs(8'h99, 8'h99, 16'h9801, 16'h2649);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=50, B=2 (Result is 100)", test_num);
            A_hex = 8'd50;
            B_hex = 8'd2;

            #1;


            check_outputs(8'h50, 8'h02, 16'h0100, 16'h0064);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=11, B=11 (Primes/Repeat)", test_num);
            A_hex = 8'd11;
            B_hex = 8'd11;

            #1;


            check_outputs(8'h11, 8'h11, 16'h0121, 16'h0079);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=99, B=5 (High-Low mix)", test_num);
            A_hex = 8'd99;
            B_hex = 8'd5;

            #1;


            check_outputs(8'h99, 8'h05, 16'h0495, 16'h01EF);
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
        input [7:0] expected_A_dec;
        input [7:0] expected_B_dec;
        input [15:0] expected_OP_dec;
        input [15:0] expected_OP_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_dec === (expected_A_dec ^ A_dec ^ expected_A_dec) &&
                expected_B_dec === (expected_B_dec ^ B_dec ^ expected_B_dec) &&
                expected_OP_dec === (expected_OP_dec ^ OP_dec ^ expected_OP_dec) &&
                expected_OP_hex === (expected_OP_hex ^ OP_hex ^ expected_OP_hex)) begin
                $display("PASS");
                $display("  Outputs: A_dec=%h, B_dec=%h, OP_dec=%h, OP_hex=%h",
                         A_dec, B_dec, OP_dec, OP_hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_dec=%h, B_dec=%h, OP_dec=%h, OP_hex=%h",
                         expected_A_dec, expected_B_dec, expected_OP_dec, expected_OP_hex);
                $display("  Got:      A_dec=%h, B_dec=%h, OP_dec=%h, OP_hex=%h",
                         A_dec, B_dec, OP_dec, OP_hex);
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
