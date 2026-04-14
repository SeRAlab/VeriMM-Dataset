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
            $display("Test Case %0d: At-the-money (S=100, K=100, T=1.0, r=0.05, sigma=0.2)", test_num);

            S     = 32'h42C80000;
            K     = 32'h42C80000;
            T     = 32'h3F800000;
            r     = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;

            #1;


            check_outputs(32'h41273591);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: In-the-money (S=110, K=100, T=1.0, r=0.05, sigma=0.2)", test_num);
            S     = 32'h42DC0000;
            K     = 32'h42C80000;
            T     = 32'h3F800000;
            r     = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;

            #1;


            check_outputs(32'h418D4D9E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-of-the-money (S=90, K=100, T=1.0, r=0.05, sigma=0.2)", test_num);
            S     = 32'h42B40000;
            K     = 32'h42C80000;
            T     = 32'h3F800000;
            r     = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;

            #1;


            check_outputs(32'h40A2E93F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Volatility (S=100, K=100, T=0.5, r=0.02, sigma=0.4)", test_num);
            S     = 32'h42C80000;
            K     = 32'h42C80000;
            T     = 32'h3F000000;
            r     = 32'h3CA3D70A;
            sigma = 32'h3ECCCCCD;

            #1;


            check_outputs(32'h413E1084);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near Maturity ITM (S=105, K=100, T=0.1, r=0.01, sigma=0.1)", test_num);
            S     = 32'h42D20000;
            K     = 32'h42C80000;
            T     = 32'h3DCCCCCD;
            r     = 32'h3C23D70A;
            sigma = 32'h3DCCCCCD;

            #1;


            check_outputs(32'h40A4C102);
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
