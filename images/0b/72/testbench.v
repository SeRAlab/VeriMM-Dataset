`timescale 1ns/1ps

module magnitude_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire A_equal;
    wire A_greater;
    wire A_less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    magnitude_comparator dut (
        .A(A),
        .B(B),
        .A_equal(A_equal),
        .A_greater(A_greater),
        .A_less(A_less)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: A=0, B=0 (Equality Case)", test_num);
        A = 4'b0000; B = 4'b0000;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: A=15, B=15 (Equality Case Max)", test_num);
        A = 4'b1111; B = 4'b1111;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: A=5, B=5 (Equality Case Mid)", test_num);
        A = 4'd5; B = 4'd5;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: A=1, B=0 (A > B, LSB)", test_num);
        A = 4'd1; B = 4'd0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: A=8, B=0 (A > B, MSB)", test_num);
        A = 4'd8; B = 4'd0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: A=15, B=0 (A > B, Max range)", test_num);
        A = 4'd15; B = 4'd0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: A=10, B=9 (A > B, Close)", test_num);
        A = 4'd10; B = 4'd9;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: A=0, B=1 (A < B, LSB)", test_num);
        A = 4'd0; B = 4'd1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: A=0, B=8 (A < B, MSB)", test_num);
        A = 4'd0; B = 4'd8;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: A=0, B=15 (A < B, Max range)", test_num);
        A = 4'd0; B = 4'd15;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: A=6, B=7 (A < B, Close)", test_num);
        A = 4'd6; B = 4'd7;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: A=12, B=3 (A > B, Mixed bits)", test_num);
        A = 4'b1100; B = 4'b0011;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("magnitude_comparator Testbench");
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
        input expected_A_equal;
        input expected_A_greater;
        input expected_A_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_equal === (expected_A_equal ^ A_equal ^ expected_A_equal) &&
                expected_A_greater === (expected_A_greater ^ A_greater ^ expected_A_greater) &&
                expected_A_less === (expected_A_less ^ A_less ^ expected_A_less)) begin
                $display("PASS");
                $display("  Outputs: A_equal=%b, A_greater=%b, A_less=%b",
                         A_equal, A_greater, A_less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_equal=%b, A_greater=%b, A_less=%b",
                         expected_A_equal, expected_A_greater, expected_A_less);
                $display("  Got:      A_equal=%b, A_greater=%b, A_less=%b",
                         A_equal, A_greater, A_less);
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
