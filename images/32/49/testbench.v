`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] K;
    reg [31:0] S;
    reg [31:0] T;
    reg [31:0] r;
    reg [31:0] sigma;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    black_scholes dut (
        .K(K),
        .S(S),
        .T(T),
        .r(r),
        .sigma(sigma),
        .C(C)
    );
    task testcase001;

    begin
        $display("\nTestcase 001: ATM Option");
        test_num = test_num + 1;
        S = 32'h42c80000;
        K = 32'h42c80000;
        T = 32'h3f800000;
        r = 32'h3d4ccccd;
        sigma = 32'h3e4ccccd;
        #1;

        check_outputs(32'h41273598);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: OTM Option");
        test_num = test_num + 1;
        S = 32'h42700000;
        K = 32'h42820000;
        T = 32'h3e800000;
        r = 32'h3da3d70a;
        sigma = 32'h3e99999a;
        #1;

        check_outputs(32'h400889c2);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: High Interest Scenario");
        test_num = test_num + 1;
        S = 32'h42c80000;
        K = 32'h42c80000;
        T = 32'h3f000000;
        r = 32'h3dcccccd;
        sigma = 32'h3dcccccd;
        #1;

        check_outputs(32'h40c46ec0);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: ITM Option");
        test_num = test_num + 1;
        S = 32'h42f00000;
        K = 32'h42c80000;
        T = 32'h3f000000;
        r = 32'h3d4ccccd;
        sigma = 32'h3e4ccccd;
        #1;

        check_outputs(32'h41baed7e);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: High Volatility Scenario");
        test_num = test_num + 1;
        S = 32'h42c80000;
        K = 32'h42c80000;
        T = 32'h40000000;
        r = 32'h00000000;
        sigma = 32'h3ecccccd;
        #1;

        check_outputs(32'h41b22998);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("black_scholes Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
