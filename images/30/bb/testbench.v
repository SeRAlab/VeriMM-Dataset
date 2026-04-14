`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] K;
    reg [31:0] S;
    reg [31:0] T;
    reg [31:0] r;
    reg [31:0] sigma;
    wire [63:0] C;

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
            $display("\nTest Case %0d: At-the-Money", test_num);
            S = 32'h42C80000;
            K = 32'h42C80000;
            T = 32'h3F800000;
            r = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;
            #1;

            check_outputs(64'h4024E6B37E000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: In-the-Money", test_num);
            S = 32'h42F00000;
            K = 32'h42C80000;
            T = 32'h3F800000;
            r = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;
            #1;

            check_outputs(64'h403A69614C000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Out-of-the-Money", test_num);
            S = 32'h42A00000;
            K = 32'h42C80000;
            T = 32'h3F800000;
            r = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;
            #1;

            check_outputs(64'h40049BC6A0000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Volatility", test_num);
            S = 32'h42C80000;
            K = 32'h42C80000;
            T = 32'h3F800000;
            r = 32'h3D4CCCCD;
            sigma = 32'h3F000000;
            #1;

            check_outputs(64'h403673A900000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Short Time to Expiry", test_num);
            S = 32'h42D20000;
            K = 32'h42C80000;
            T = 32'h3DCCCCCD;
            r = 32'h3CA3D70A;
            sigma = 32'h3E4CCCCD;
            #1;

            check_outputs(64'h4015A45A00000000);
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
        input [63:0] expected_C;
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
