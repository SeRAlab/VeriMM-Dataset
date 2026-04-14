`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] K;
    reg [15:0] S;
    reg [7:0] T;
    reg [7:0] r;
    reg [7:0] sigma;
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
            $display("Test Case %0d: At-the-Money (S=100, K=100, T=1.0, r=0.05, vol=0.2)", test_num);

            S = 16'h6400;
            K = 16'h6400;
            T = 8'h10;
            r = 8'h0D;
            sigma = 8'h33;
            #1;

            check_outputs(32'h000A735D);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: In-the-Money (S=110, K=100, T=1.0, r=0.05, vol=0.2)", test_num);

            S = 16'h6E00;
            K = 16'h6400;
            T = 8'h10;
            r = 8'h0D;
            sigma = 8'h33;
            #1;

            check_outputs(32'h0011AC69);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-of-the-Money (S=90, K=100, T=1.0, r=0.05, vol=0.2)", test_num);

            S = 16'h5A00;
            K = 16'h6400;
            T = 8'h10;
            r = 8'h0D;
            sigma = 8'h33;
            #1;

            check_outputs(32'h00051687);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Short Time to Expiration (T=0.25)", test_num);

            S = 16'h6400;
            K = 16'h6400;
            T = 8'h04;
            r = 8'h0D;
            sigma = 8'h33;
            #1;

            check_outputs(32'h00049EB8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Volatility and High Interest (vol=0.4, r=0.1)", test_num);

            S = 16'h6400;
            K = 16'h6400;
            T = 8'h10;
            r = 8'h1A;
            sigma = 8'h66;
            #1;

            check_outputs(32'h001452EB);
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
