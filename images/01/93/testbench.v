`timescale 1ns/1ps

module BlackScholes_tb;

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
    BlackScholes dut (
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
        S = 32'd100;
        K = 32'd100;
        T = 32'd1;
        r = 32'h00000CCC;
        sigma = 32'h00003333;
        #1;

        check_outputs(32'h000A735E);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Out-of-the-Money (OTM) Option", test_num);
        S = 32'd80;
        K = 32'd100;
        T = 32'd1;
        r = 32'h00000CCC;
        sigma = 32'h00003333;
        #1;

        check_outputs(32'h00035512);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: In-the-Money (ITM) Option", test_num);
        S = 32'd120;
        K = 32'd100;
        T = 32'd1;
        r = 32'h00000CCC;
        sigma = 32'h00003333;
        #1;

        check_outputs(32'h00186312);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Long Duration Option (T=2)", test_num);
        S = 32'd100;
        K = 32'd100;
        T = 32'd2;
        r = 32'h00000CCC;
        sigma = 32'h00003333;
        #1;

        check_outputs(32'h000EFA5B);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High Volatility (sigma=0.40)", test_num);
        S = 32'd100;
        K = 32'd100;
        T = 32'd1;
        r = 32'h00000CCC;
        sigma = 32'h00006666;
        #1;

        check_outputs(32'h0011FFB9);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BlackScholes Testbench");
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
