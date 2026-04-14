`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] asset_returns;
    wire [4:0] allocation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset_returns(asset_returns),
        .allocation(allocation)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros - No returns", test_num);
            asset_returns = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones - All assets have positive returns", test_num);
            asset_returns = 5'b11111;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern 10101", test_num);
            asset_returns = 5'b10101;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern 01010", test_num);
            asset_returns = 5'b01010;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single asset return (MSB)", test_num);
            asset_returns = 5'b10000;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single asset return (LSB)", test_num);
            asset_returns = 5'b00001;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 11001", test_num);
            asset_returns = 5'b11001;
            #1;

            check_outputs(5'b11001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle asset return", test_num);
            asset_returns = 5'b00100;
            #1;

            check_outputs(5'b00100);
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
        input [4:0] expected_allocation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allocation === (expected_allocation ^ allocation ^ expected_allocation)) begin
                $display("PASS");
                $display("  Outputs: allocation=%h",
                         allocation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocation=%h",
                         expected_allocation);
                $display("  Got:      allocation=%h",
                         allocation);
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
