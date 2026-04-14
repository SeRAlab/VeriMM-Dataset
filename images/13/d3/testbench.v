`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] K;
    reg [9:0] S;
    reg [4:0] T;
    reg [4:0] r;
    reg [4:0] sigma;
    wire [15:0] C;
    wire [15:0] P;

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
        .C(C),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ITM Call at Expiration (S=200, K=100, T=0)", test_num);
            S = 10'd200;
            K = 10'd100;
            T = 5'd0;
            r = 5'd5;
            sigma = 5'd20;
            #1;

            check_outputs(16'h1900, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ITM Put at Expiration (S=100, K=250, T=0)", test_num);
            S = 10'd100;
            K = 10'd250;
            T = 5'd0;
            r = 5'd2;
            sigma = 5'd15;
            #1;

            check_outputs(16'h0000, 16'h2580);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ATM at Expiration (S=300, K=300, T=0)", test_num);
            S = 10'd300;
            K = 10'd300;
            T = 5'd0;
            r = 5'd10;
            sigma = 5'd30;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Max S, Min K (S=1023, K=0, T=0)", test_num);
            S = 10'h3FF;
            K = 10'h000;
            T = 5'd0;
            r = 5'd0;
            sigma = 5'd0;
            #1;

            check_outputs(16'hFFC0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Min S, Max K (S=0, K=1023, T=0)", test_num);
            S = 10'h000;
            K = 10'h3FF;
            T = 5'd0;
            r = 5'd31;
            sigma = 5'd31;
            #1;

            check_outputs(16'h0000, 16'hFFC0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ATM with Max Rate/Vol at Expiry", test_num);
            S = 10'd500;
            K = 10'd500;
            T = 5'd0;
            r = 5'd31;
            sigma = 5'd31;
            #1;

            check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_C;
        input [15:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: C=%h, P=%h",
                         C, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, P=%h",
                         expected_C, expected_P);
                $display("  Got:      C=%h, P=%h",
                         C, P);
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
