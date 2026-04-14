`timescale 1ns/1ps

module binary_search_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_search_comparator dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd0;
        $display("Test %0d: A=%d, B=%d (Expect Equal: 0)", test_num, A, B);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd15;
        $display("Test %0d: A=%d, B=%d (Expect Equal: 0)", test_num, A, B);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'd4; B = 4'd5;
        $display("Test %0d: A=%d, B=%d (Expect Less: 1)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'd5; B = 4'd4;
        $display("Test %0d: A=%d, B=%d (Expect Greater: -1/3)", test_num, A, B);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'd0; B = 4'd15;
        $display("Test %0d: A=%d, B=%d (Expect Less: 1)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'd15; B = 4'd0;
        $display("Test %0d: A=%d, B=%d (Expect Greater: -1/3)", test_num, A, B);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'd8; B = 4'd8;
        $display("Test %0d: A=%d, B=%d (Expect Equal: 0)", test_num, A, B);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'b0111; B = 4'b1000;
        $display("Test %0d: A=%b, B=%b (Expect Less: 1)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'b1011; B = 4'b1010;
        $display("Test %0d: A=%b, B=%b (Expect Greater: -1/3)", test_num, A, B);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'd10; B = 4'd12;
        $display("Test %0d: A=%d, B=%d (Expect Less: 1)", test_num, A, B);
        #1;

        check_outputs(2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_search_comparator Testbench");
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
        input [1:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
