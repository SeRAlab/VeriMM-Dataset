`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] K;
    reg [15:0] S;
    reg [15:0] r;
    reg [15:0] sigma;
    reg [15:0] t;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    black_scholes dut (
        .K(K),
        .S(S),
        .r(r),
        .sigma(sigma),
        .t(t),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Out-of-the-Money (OTM) - S < K", test_num);

            S = 16'h3200;
            K = 16'h6400;
            r = 16'h000D;
            sigma = 16'h0033;
            t = 16'h0100;


            #1;



            check_outputs(32'h00000020);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: At-the-Money (ATM) - S = K", test_num);

            S = 16'h6400;
            K = 16'h6400;
            r = 16'h000D;
            sigma = 16'h0033;
            t = 16'h0100;



            #1;




            check_outputs(32'h000A7333);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: In-the-Money (ITM) - S > K", test_num);

            S = 16'h9600;
            K = 16'h6400;
            r = 16'h000D;
            sigma = 16'h0033;
            t = 16'h0100;



            #1;




            check_outputs(32'h0036CCCD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Volatility Impact", test_num);

            S = 16'h6400;
            K = 16'h6400;
            r = 16'h000D;
            sigma = 16'h00CD;
            t = 16'h0100;



            #1;




            check_outputs(32'h00210000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Near Expiration (Short Time)", test_num);

            S = 16'h6E00;
            K = 16'h6400;
            r = 16'h000D;
            sigma = 16'h0033;
            t = 16'h0003;



            #1;




            check_outputs(32'h000A0CCD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Risk-Free Rate", test_num);

            S = 16'h6400;
            K = 16'h6400;
            r = 16'h0000;
            sigma = 16'h0033;
            t = 16'h0100;



            #1;




            check_outputs(32'h0007F5C2);
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
