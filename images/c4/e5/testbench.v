`timescale 1ns/1ps

module comparator_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [1:0] EQ_LT_GT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_4bit dut (
        .A(A),
        .B(B),
        .EQ_LT_GT(EQ_LT_GT)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000; B = 4'b0000;
        $display("Testcase %03d: A=%d, B=%d (Expect EQ)", test_num, A, B);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b1111; B = 4'b1111;
        $display("Testcase %03d: A=%d, B=%d (Expect EQ)", test_num, A, B);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1010; B = 4'b1010;
        $display("Testcase %03d: A=%d, B=%d (Expect EQ)", test_num, A, B);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b0000; B = 4'b1111;
        $display("Testcase %03d: A=%d, B=%d (Expect LT)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b0110; B = 4'b0111;
        $display("Testcase %03d: A=%d, B=%d (Expect LT)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b0111; B = 4'b1000;
        $display("Testcase %03d: A=%d, B=%d (Expect LT)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1111; B = 4'b0000;
        $display("Testcase %03d: A=%d, B=%d (Expect GT)", test_num, A, B);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'b1001; B = 4'b1000;
        $display("Testcase %03d: A=%d, B=%d (Expect GT)", test_num, A, B);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'b1000; B = 4'b0111;
        $display("Testcase %03d: A=%d, B=%d (Expect GT)", test_num, A, B);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b1011; B = 4'b0101;
        $display("Testcase %03d: A=%d, B=%d (Expect GT)", test_num, A, B);
        #1;

        check_outputs(2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_4bit Testbench");
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
        input [1:0] expected_EQ_LT_GT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ_LT_GT === (expected_EQ_LT_GT ^ EQ_LT_GT ^ expected_EQ_LT_GT)) begin
                $display("PASS");
                $display("  Outputs: EQ_LT_GT=%h",
                         EQ_LT_GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ_LT_GT=%h",
                         expected_EQ_LT_GT);
                $display("  Got:      EQ_LT_GT=%h",
                         EQ_LT_GT);
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
