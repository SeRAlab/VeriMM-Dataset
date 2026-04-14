`timescale 1ns/1ps

module call_option_payoff_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_price;
    reg [15:0] strike_price;
    wire [15:0] payoff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    call_option_payoff dut (
        .current_price(current_price),
        .strike_price(strike_price),
        .payoff(payoff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: In-the-money", test_num);
            current_price = 16'd150;
            strike_price = 16'd100;

            #1;


            check_outputs(16'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Out-of-the-money", test_num);
            current_price = 16'd80;
            strike_price = 16'd120;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: At-the-money", test_num);
            current_price = 16'd250;
            strike_price = 16'd250;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large values In-the-money", test_num);
            current_price = 16'd60000;
            strike_price = 16'd10000;

            #1;


            check_outputs(16'd50000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small difference In-the-money", test_num);
            current_price = 16'd1001;
            strike_price = 16'd1000;

            #1;


            check_outputs(16'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Strike price zero", test_num);
            current_price = 16'd500;
            strike_price = 16'd0;

            #1;


            check_outputs(16'd500);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Current price zero", test_num);
            current_price = 16'd0;
            strike_price = 16'd100;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary values", test_num);
            current_price = 16'hFFFF;
            strike_price = 16'h0001;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("call_option_payoff Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_payoff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_payoff === (expected_payoff ^ payoff ^ expected_payoff)) begin
                $display("PASS");
                $display("  Outputs: payoff=%h",
                         payoff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: payoff=%h",
                         expected_payoff);
                $display("  Got:      payoff=%h",
                         payoff);
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
