`timescale 1ns/1ps

module option_pricing_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] K;
    reg [31:0] S;
    reg [31:0] T;
    reg [31:0] r;
    reg [31:0] sigma;
    wire [31:0] call_price;
    wire [31:0] put_price;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    option_pricing dut (
        .K(K),
        .S(S),
        .T(T),
        .r(r),
        .sigma(sigma),
        .call_price(call_price),
        .put_price(put_price)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: At-the-money (S=K)", test_num);
            S = 32'h42C80000;
            K = 32'h42C80000;
            T = 32'h3F800000;
            r = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;
            #1;

            check_outputs(32'h4127359E, 32'h40B25A24);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: In-the-money Call (S > K)", test_num);
            S = 32'h42F00000;
            K = 32'h42C80000;
            T = 32'h3F000000;
            r = 32'h3D75C28F;
            sigma = 32'h3E99999A;
            #1;

            check_outputs(32'h41CA1EBA, 32'h4071DC64);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Out-of-the-money Call (S < K)", test_num);
            S = 32'h42A00000;
            K = 32'h42C80000;
            T = 32'h3E800000;
            r = 32'h3C23D70A;
            sigma = 32'h3ECCCCCD;
            #1;

            check_outputs(32'h3F581062, 32'h41A4C28F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: High Volatility (sigma=0.8)", test_num);
            S = 32'h42C80000;
            K = 32'h42C80000;
            T = 32'h3F800000;
            r = 32'h3D4CCCCD;
            sigma = 32'h3F4CCCCD;
            #1;

            check_outputs(32'h4207A3D7, 32'h41E83D71);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Near Expiration (T=0.01)", test_num);
            S = 32'h42D20000;
            K = 32'h42C80000;
            T = 32'h3C23D70A;
            r = 32'h3D4CCCCD;
            sigma = 32'h3E4CCCCD;
            #1;

            check_outputs(32'h40A1999A, 32'h38D1B717);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("option_pricing Testbench");
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
        input [31:0] expected_put_price;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_call_price === (expected_call_price ^ call_price ^ expected_call_price) &&
                expected_put_price === (expected_put_price ^ put_price ^ expected_put_price)) begin
                $display("PASS");
                $display("  Outputs: call_price=%h, put_price=%h",
                         call_price, put_price);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: call_price=%h, put_price=%h",
                         expected_call_price, expected_put_price);
                $display("  Got:      call_price=%h, put_price=%h",
                         call_price, put_price);
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
