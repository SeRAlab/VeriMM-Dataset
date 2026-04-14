`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Op1;
    reg [31:0] Op2;
    reg [2:0] S_Op;
    wire [31:0] R_Op;
    wire ZF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Op1(Op1),
        .Op2(Op2),
        .S_Op(S_Op),
        .R_Op(R_Op),
        .ZF(ZF)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            Op1 = 32'd50;
            Op2 = 32'd75;
            S_Op = 3'd0;
            $display("Test %0d: Addition (50 + 75)", test_num);
            #1;

            check_outputs(32'd125, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            Op1 = 32'd200;
            Op2 = 32'd80;
            S_Op = 3'd1;
            $display("Test %0d: Subtraction (200 - 80)", test_num);
            #1;

            check_outputs(32'd120, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            Op1 = 32'd12;
            Op2 = 32'd11;
            S_Op = 3'd2;
            $display("Test %0d: Multiplication (12 * 11)", test_num);
            #1;

            check_outputs(32'd132, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            Op1 = 32'd144;
            Op2 = 32'd12;
            S_Op = 3'd3;
            $display("Test %0d: Division (144 / 12)", test_num);
            #1;

            check_outputs(32'd12, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            Op1 = 32'hAAAA_5555;
            Op2 = 32'h5555_0000;
            S_Op = 3'd4;
            $display("Test %0d: Bitwise OR (hAAAA5555 | h55550000)", test_num);
            #1;

            check_outputs(32'hFFFF_5555, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            Op1 = 32'hFFFF_FFFF;
            Op2 = 32'h1234_5678;
            S_Op = 3'd5;
            $display("Test %0d: Bitwise AND (hFFFFFFFF & h12345678)", test_num);
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            Op1 = 32'd10;
            Op2 = 32'd20;
            S_Op = 3'd6;
            $display("Test %0d: Less Than (10 < 20)", test_num);
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            Op1 = 32'd100;
            Op2 = 32'd50;
            S_Op = 3'd6;
            $display("Test %0d: Less Than (100 < 50)", test_num);
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            Op1 = 32'd42;
            Op2 = 32'd42;
            S_Op = 3'd1;
            $display("Test %0d: Zero Flag Check (42 - 42)", test_num);
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            Op1 = 32'hAAAA_AAAA;
            Op2 = 32'h5555_5555;
            S_Op = 3'd5;
            $display("Test %0d: Zero Flag Check (hAAAAAAAA & h55555555)", test_num);
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            Op1 = 32'd1;
            Op2 = 32'd1;
            S_Op = 3'd7;
            $display("Test %0d: Unsupported Operation (S_Op=7)", test_num);

            #1;


            check_outputs(32'bx, 1'bx);
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
        input [31:0] expected_R_Op;
        input expected_ZF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R_Op === (expected_R_Op ^ R_Op ^ expected_R_Op) &&
                expected_ZF === (expected_ZF ^ ZF ^ expected_ZF)) begin
                $display("PASS");
                $display("  Outputs: R_Op=%h, ZF=%b",
                         R_Op, ZF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R_Op=%h, ZF=%b",
                         expected_R_Op, expected_ZF);
                $display("  Got:      R_Op=%h, ZF=%b",
                         R_Op, ZF);
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
