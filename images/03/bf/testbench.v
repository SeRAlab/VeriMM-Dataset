`timescale 1ns/1ps

module magnitude_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire A_EQ_B;
    wire A_GT_B;
    wire A_LT_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    magnitude_comparator dut (
        .A(A),
        .B(B),
        .A_EQ_B(A_EQ_B),
        .A_GT_B(A_GT_B),
        .A_LT_B(A_LT_B)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: A=0, B=0 (Equality at Minimum)", test_num);
        A = 5'd0;
        B = 5'd0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: A=31, B=31 (Equality at Maximum)", test_num);
        A = 5'd31;
        B = 5'd31;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: A=10, B=5 (A > B, Standard)", test_num);
        A = 5'd10;
        B = 5'd5;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: A=5, B=10 (A < B, Standard)", test_num);
        A = 5'd5;
        B = 5'd10;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: A=16, B=15 (A > B, MSB Difference)", test_num);
        A = 5'b10000;
        B = 5'b01111;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: A=15, B=16 (A < B, MSB Difference)", test_num);
        A = 5'b01111;
        B = 5'b10000;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: A=1, B=0 (A > B, LSB Difference)", test_num);
        A = 5'b00001;
        B = 5'b00000;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: A=30, B=31 (A < B, LSB Difference)", test_num);
        A = 5'b11110;
        B = 5'b11111;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: A=21, B=21 (Mid-range Equality)", test_num);
        A = 5'd21;
        B = 5'd21;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: A=25, B=7 (A > B, Mixed bits)", test_num);
        A = 5'd25;
        B = 5'd7;
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
        input expected_A_EQ_B;
        input expected_A_GT_B;
        input expected_A_LT_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_EQ_B === (expected_A_EQ_B ^ A_EQ_B ^ expected_A_EQ_B) &&
                expected_A_GT_B === (expected_A_GT_B ^ A_GT_B ^ expected_A_GT_B) &&
                expected_A_LT_B === (expected_A_LT_B ^ A_LT_B ^ expected_A_LT_B)) begin
                $display("PASS");
                $display("  Outputs: A_EQ_B=%b, A_GT_B=%b, A_LT_B=%b",
                         A_EQ_B, A_GT_B, A_LT_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_EQ_B=%b, A_GT_B=%b, A_LT_B=%b",
                         expected_A_EQ_B, expected_A_GT_B, expected_A_LT_B);
                $display("  Got:      A_EQ_B=%b, A_GT_B=%b, A_LT_B=%b",
                         A_EQ_B, A_GT_B, A_LT_B);
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
