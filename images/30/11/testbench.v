`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] K;
    reg [15:0] S;
    reg [15:0] T;
    reg [15:0] r;
    reg [15:0] sigma;
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
            $display("Test Case %0d: At-the-Money (S=K)", test_num);


            S = 16'h6400;
            K = 16'h6400;
            T = 16'h0100;
            r = 16'h000D;
            sigma = 16'h0033;
            #1;

            check_outputs(32'h000A7333);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Deep In-the-Money (S > K)", test_num);


            S = 16'h7800;
            K = 16'h6400;
            T = 16'h0080;
            r = 16'h000D;
            sigma = 16'h0033;
            #1;

            check_outputs(32'h001670A3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-of-the-Money (S < K)", test_num);


            S = 16'h5000;
            K = 16'h6400;
            T = 16'h0100;
            r = 16'h000D;
            sigma = 16'h0033;
            #1;

            check_outputs(32'h000270A3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Volatility ATM", test_num);


            S = 16'h6400;
            K = 16'h6400;
            T = 16'h0100;
            r = 16'h000D;
            sigma = 16'h0080;
            #1;

            check_outputs(32'h00168000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Short Time to Maturity", test_num);


            S = 16'h6900;
            K = 16'h6400;
            T = 16'h001A;
            r = 16'h000D;
            sigma = 16'h0033;
            #1;

            check_outputs(32'h00059C28);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Interest Rate", test_num);


            S = 16'h6400;
            K = 16'h6400;
            T = 16'h0100;
            r = 16'h0000;
            sigma = 16'h0033;
            #1;

            check_outputs(32'h0007F851);
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
        testcase006();
        
        
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
