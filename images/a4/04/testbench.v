`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] OPR;
    wire [3:0] FLAGS;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OPR(OPR),
        .FLAGS(FLAGS),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pass B directly", test_num);
            A = 8'h12;
            B = 8'h34;
            OPR = 3'b000;

            #1;


            check_outputs(4'b0000, 8'h34);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Normal)", test_num);
            A = 8'h05;
            B = 8'h03;
            OPR = 3'b001;

            #1;


            check_outputs(4'b0000, 8'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Carry and Zero)", test_num);
            A = 8'hFF;
            B = 8'h01;
            OPR = 3'b001;

            #1;


            check_outputs(4'b1010, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Signed Overflow)", test_num);
            A = 8'h7F;
            B = 8'h01;
            OPR = 3'b001;

            #1;


            check_outputs(4'b0101, 8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Normal)", test_num);
            A = 8'h10;
            B = 8'h05;
            OPR = 3'b010;

            #1;


            check_outputs(4'b0000, 8'h0B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Borrow/Carry)", test_num);
            A = 8'h05;
            B = 8'h10;
            OPR = 3'b010;

            #1;


            check_outputs(4'b0110, 8'hF5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Signed Overflow)", test_num);
            A = 8'h80;
            B = 8'h01;
            OPR = 3'b010;

            #1;


            check_outputs(4'b0001, 8'h7F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            A = 8'hAA;
            B = 8'hF0;
            OPR = 3'b011;

            #1;


            check_outputs(4'b0100, 8'hA0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            A = 8'h0F;
            B = 8'hF0;
            OPR = 3'b100;

            #1;


            check_outputs(4'b0100, 8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR (Zero result)", test_num);
            A = 8'h55;
            B = 8'h55;
            OPR = 3'b101;

            #1;


            check_outputs(4'b1000, 8'h00);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Logical Shift Left A", test_num);
            A = 8'h81;
            B = 8'h00;
            OPR = 3'b110;

            #1;


            check_outputs(4'b0000, 8'h02);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rotate Left A", test_num);
            A = 8'h81;
            B = 8'h00;
            OPR = 3'b111;

            #1;


            check_outputs(4'b0000, 8'h03);
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
        testcase012();
        
        
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
        input [3:0] expected_FLAGS;
        input [7:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FLAGS === (expected_FLAGS ^ FLAGS ^ expected_FLAGS) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: FLAGS=%h, R=%h",
                         FLAGS, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FLAGS=%h, R=%h",
                         expected_FLAGS, expected_R);
                $display("  Got:      FLAGS=%h, R=%h",
                         FLAGS, R);
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
