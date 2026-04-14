`timescale 1ns/1ps

module black_scholes_option_price_tb;

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
    black_scholes_option_price dut (
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
            $display("Test Case %0d: At-the-Money (ATM) - S=100, K=100, T=1, r=5%%, sigma=20%%", test_num);


            S = 32'h00640000;
            K = 32'h00640000;
            T = 32'h00010000;
            r = 32'h00000CCD;
            sigma = 32'h00003333;

            #1;


            check_outputs(32'h000A7333);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: In-the-Money (ITM) - S=120, K=100, T=1, r=5%%, sigma=20%%", test_num);


            S = 32'h00780000;
            K = 32'h00640000;
            T = 32'h00010000;
            r = 32'h00000CCD;
            sigma = 32'h00003333;

            #1;


            check_outputs(32'h001B8F5C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-of-the-Money (OTM) - S=80, K=100, T=1, r=5%%, sigma=20%%", test_num);

            S = 32'h00500000;
            K = 32'h00640000;
            T = 32'h00010000;
            r = 32'h00000CCD;
            sigma = 32'h00003333;

            #1;


            check_outputs(32'h000263D7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Volatility Scenario - S=100, K=100, T=0.5, r=2%%, sigma=50%%", test_num);


            S = 32'h00640000;
            K = 32'h00640000;
            T = 32'h00008000;
            r = 32'h0000051E;
            sigma = 32'h00008000;

            #1;


            check_outputs(32'h000E7851);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Deep ITM Near Expiration - S=150, K=100, T=0.1, r=5%%, sigma=10%%", test_num);


            S = 32'h00960000;
            K = 32'h00640000;
            T = 32'h00001999;
            r = 32'h00000CCD;
            sigma = 32'h00001999;


            #1;



            check_outputs(32'h00328000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("black_scholes_option_price Testbench");
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
