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
            test_num = test_num + 1;
            $display("Test Case %0d: At-the-money, Standard Volatility", test_num);

            S     = 32'h42c80000;
            K     = 32'h42c80000;
            T     = 32'h3f800000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;

            #1;


            check_outputs(32'h41273593);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: In-the-money, High Volatility", test_num);

            S     = 32'h42f00000;
            K     = 32'h42c80000;
            T     = 32'h3f000000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e99999a;

            #1;


            check_outputs(32'h41ca213b);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-of-the-money, Long Duration", test_num);

            S     = 32'h42a00000;
            K     = 32'h42c80000;
            T     = 32'h40000000;
            r     = 32'h3ca3d70a;
            sigma = 32'h3e800000;

            #1;


            check_outputs(32'h40b9faba);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Volatility, Low Interest", test_num);

            S     = 32'h42c80000;
            K     = 32'h42b40000;
            T     = 32'h3e800000;
            r     = 32'h3c23d70a;
            sigma = 32'h3dcccccd;

            #1;


            check_outputs(32'h4125e354);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Strike (Deep OTM)", test_num);

            S     = 32'h42480000;
            K     = 32'h42c80000;
            T     = 32'h3f000000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;

            #1;


            check_outputs(32'h3ad1b717);
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
