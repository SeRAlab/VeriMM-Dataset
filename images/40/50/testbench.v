`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] investment1;
    reg [4:0] investment2;
    reg [4:0] investment3;
    wire [4:0] optimal_investment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .investment1(investment1),
        .investment2(investment2),
        .investment3(investment3),
        .optimal_investment(optimal_investment)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero", test_num);
        investment1 = 5'b00000;
        investment2 = 5'b00000;
        investment3 = 5'b00000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs maximum (all ones)", test_num);
        investment1 = 5'b11111;
        investment2 = 5'b11111;
        investment3 = 5'b11111;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: One input is zero", test_num);
        investment1 = 5'b11111;
        investment2 = 5'b00000;
        investment3 = 5'b11111;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overlapping nested values", test_num);
        investment1 = 5'b01111;
        investment2 = 5'b00111;
        investment3 = 5'b00011;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Disjoint bit patterns", test_num);
        investment1 = 5'b10101;
        investment2 = 5'b01010;
        investment3 = 5'b11111;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed bits - single bit common", test_num);
        investment1 = 5'b10010;
        investment2 = 5'b10100;
        investment3 = 5'b11000;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complex bit pattern", test_num);
        investment1 = 5'b11011;
        investment2 = 5'b01101;
        investment3 = 5'b01011;
        #1;

        check_outputs(5'b01001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits", test_num);
        investment1 = 5'b10101;
        investment2 = 5'b11101;
        investment3 = 5'b10111;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [4:0] expected_optimal_investment;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimal_investment === (expected_optimal_investment ^ optimal_investment ^ expected_optimal_investment)) begin
                $display("PASS");
                $display("  Outputs: optimal_investment=%h",
                         optimal_investment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimal_investment=%h",
                         expected_optimal_investment);
                $display("  Got:      optimal_investment=%h",
                         optimal_investment);
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
