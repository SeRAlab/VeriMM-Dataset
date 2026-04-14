`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [4:0] C_out;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            A = 4'b0000;
            B = 4'b0000;
            C = 4'b0000;

            #1;


            check_outputs(5'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Inputs (15, 15, 15)", test_num);
            A = 4'b1111;
            B = 4'b1111;
            C = 4'b1111;

            #1;


            check_outputs(5'h1E, 5'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Input Active (15, 0, 0)", test_num);
            A = 4'b1111;
            B = 4'b0000;
            C = 4'b0000;

            #1;


            check_outputs(5'h00, 5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bitwise Carries (1, 1, 1)", test_num);
            A = 4'b0001;
            B = 4'b0001;
            C = 4'b0001;

            #1;


            check_outputs(5'h02, 5'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (10, 5, 3)", test_num);
            A = 4'd10;
            B = 4'd5;
            C = 4'd3;







            #1;








            check_outputs(5'h06, 5'h0C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Powers of Two (1, 2, 4)", test_num);
            A = 4'd1;
            B = 4'd2;
            C = 4'd4;

            #1;


            check_outputs(5'h00, 5'h07);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Carry at MSB (8, 8, 8)", test_num);
            A = 4'b1000;
            B = 4'b1000;
            C = 4'b1000;

            #1;


            check_outputs(5'h10, 5'h08);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Mix (7, 7, 7)", test_num);
            A = 4'd7;
            B = 4'd7;
            C = 4'd7;

            #1;


            check_outputs(5'h0E, 5'h07);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_save_adder Testbench");
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
        input [4:0] expected_C_out;
        input [4:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C_out=%h, S=%h",
                         C_out, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%h, S=%h",
                         expected_C_out, expected_S);
                $display("  Got:      C_out=%h, S=%h",
                         C_out, S);
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
