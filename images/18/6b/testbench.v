`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] K;
    reg [31:0] S;
    reg [31:0] T;
    reg [31:0] r;
    reg [31:0] sigma;
    wire [31:0] call_price;

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
        .call_price(call_price)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: At-the-Money (ATM) Option", test_num);

            S = 32'h42c80000;
            K = 32'h42c80000;
            T = 32'h3f800000;
            r = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;

            #1;


            check_outputs(32'h41273595);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: In-the-Money (ITM) Option", test_num);

            S = 32'h42dc0000;
            K = 32'h42c80000;
            T = 32'h3f800000;
            r = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;

            #1;


            check_outputs(32'h418d4d96);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out-of-the-Money (OTM) Option", test_num);

            S = 32'h42b40000;
            K = 32'h42c80000;
            T = 32'h3f800000;
            r = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;

            #1;


            check_outputs(32'h40a2e912);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Volatility ATM", test_num);

            S = 32'h42c80000;
            K = 32'h42c80000;
            T = 32'h3f000000;
            r = 32'h3dcccccd;
            sigma = 32'h3f000000;

            #1;


            check_outputs(32'h41844396);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Volatility / Short Time", test_num);

            S = 32'h42d20000;
            K = 32'h42c80000;
            T = 32'h3dcccccd;
            r = 32'h3ca3d70a;
            sigma = 32'h3dcccccd;

            #1;


            check_outputs(32'h40aa24dd);
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
        input [31:0] expected_call_price;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_call_price === (expected_call_price ^ call_price ^ expected_call_price)) begin
                $display("PASS");
                $display("  Outputs: call_price=%h",
                         call_price);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: call_price=%h",
                         expected_call_price);
                $display("  Got:      call_price=%h",
                         call_price);
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
