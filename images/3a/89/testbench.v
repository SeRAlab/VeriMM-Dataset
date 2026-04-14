`timescale 1ns/1ps

module black_scholes_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] K;
    reg [7:0] S;
    reg [7:0] T;
    reg [7:0] r;
    reg [7:0] sigma;
    wire [15:0] option_price;

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
        .option_price(option_price)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: At-the-money", test_num);
            S = 8'd100;
            K = 8'd100;
            T = 8'h10;
            r = 8'h01;
            sigma = 8'h03;
            #1;

            check_outputs(16'h0A73);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: In-the-money", test_num);
            S = 8'd120;
            K = 8'd100;
            T = 8'h10;
            r = 8'h01;
            sigma = 8'h03;
            #1;

            check_outputs(16'h1880);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Out-of-the-money", test_num);
            S = 8'd80;
            K = 8'd100;
            T = 8'h10;
            r = 8'h01;
            sigma = 8'h03;
            #1;

            check_outputs(16'h0300);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Short time to expiration", test_num);
            S = 8'd100;
            K = 8'd100;
            T = 8'h02;
            r = 8'h01;
            sigma = 8'h03;
            #1;

            check_outputs(16'h02C0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Volatility", test_num);
            S = 8'd100;
            K = 8'd100;
            T = 8'h10;
            r = 8'h01;
            sigma = 8'h0C;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Deep Out-of-the-money", test_num);
            S = 8'd20;
            K = 8'd150;
            T = 8'h10;
            r = 8'h01;
            sigma = 8'h02;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_option_price;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_option_price === (expected_option_price ^ option_price ^ expected_option_price)) begin
                $display("PASS");
                $display("  Outputs: option_price=%h",
                         option_price);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: option_price=%h",
                         expected_option_price);
                $display("  Got:      option_price=%h",
                         option_price);
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
