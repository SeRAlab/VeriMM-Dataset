`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd0;
            B = 4'd0;
            $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd5;
            B = 4'd3;
            $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd10;
            B = 4'd5;
            $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd8;
            B = 4'd8;
            $display("Test Case %0d: A=%d, B=%d (Carry bit check)", test_num, A, B);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'd15;
            B = 4'd1;
            $display("Test Case %0d: A=%d, B=%d (Max A + 1)", test_num, A, B);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'd15;
            B = 4'd15;
            $display("Test Case %0d: A=%d, B=%d (Max sum check)", test_num, A, B);
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b1010;
            B = 4'b0110;
            $display("Test Case %0d: A=%b, B=%b", test_num, A, B);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b0111;
            B = 4'b0010;
            $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input expected_C;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
