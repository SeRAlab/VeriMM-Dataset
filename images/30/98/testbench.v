`timescale 1ns/1ps

module black_scholes_call_option_tb;

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
    black_scholes_call_option dut (
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
            $display("Testcase %0d: ATM Option", test_num);
            S     = 32'h42c80000;
            K     = 32'h42c80000;
            T     = 32'h3f800000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;
            #1;

            check_outputs(32'h41273595);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ITM Option", test_num);
            S     = 32'h42f00000;
            K     = 32'h42c80000;
            T     = 32'h3f800000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;
            #1;

            check_outputs(32'h41ce238b);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OTM Option", test_num);
            S     = 32'h42a00000;
            K     = 32'h42c80000;
            T     = 32'h3f800000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;
            #1;

            check_outputs(32'h40242299);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Volatility", test_num);
            S     = 32'h42c80000;
            K     = 32'h42c80000;
            T     = 32'h3f800000;
            r     = 32'h3d4ccccd;
            sigma = 32'h3f000000;
            #1;

            check_outputs(32'h41ae5746);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Short Time to Expiry", test_num);
            S     = 32'h42c80000;
            K     = 32'h42c80000;
            T     = 32'h3dcccccd;
            r     = 32'h3d4ccccd;
            sigma = 32'h3e4ccccd;
            #1;

            check_outputs(32'h402eb928);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("black_scholes_call_option Testbench");
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
