`timescale 1ns/1ps

module two_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire COUT;
    wire [2:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    two_bit_adder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 2'b00;
            B = 2'b00;
            $display("Test Case 001: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 2'b01;
            B = 2'b01;
            $display("Test Case 002: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 2'b10;
            B = 2'b01;
            $display("Test Case 003: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 2'b11;
            B = 2'b01;
            $display("Test Case 004: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 2'b10;
            B = 2'b10;
            $display("Test Case 005: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 2'b11;
            B = 2'b10;
            $display("Test Case 006: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 2'b11;
            B = 2'b11;
            $display("Test Case 007: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 2'b00;
            B = 2'b11;
            $display("Test Case 008: A=%d, B=%d", A, B);
            #1;

            check_outputs(1'b0, 3'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("two_bit_adder Testbench");
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
        input expected_COUT;
        input [2:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
