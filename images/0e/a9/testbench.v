`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] assets;
    wire [4:0] optimal_selection;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .assets(assets),
        .optimal_selection(optimal_selection)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            assets = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 4 is 1, Bit 3 is 0 (Constraint not active)", test_num);
            assets = 5'b10000;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 4 is 0, Bit 3 is 1 (Constraint active but bit 4 already 0)", test_num);
            assets = 5'b01000;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 4 is 1, Bit 3 is 1 (Constraint active, Bit 4 must be cleared)", test_num);
            assets = 5'b11000;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits 1 (Constraint active, Bit 4 cleared, others stay 1)", test_num);
            assets = 5'b11111;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits with bit 3=0", test_num);
            assets = 5'b10101;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits with bit 3=1", test_num);
            assets = 5'b11010;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower bits only", test_num);
            assets = 5'b00111;
            #1;

            check_outputs(5'b00111);
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
        input [4:0] expected_optimal_selection;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimal_selection === (expected_optimal_selection ^ optimal_selection ^ expected_optimal_selection)) begin
                $display("PASS");
                $display("  Outputs: optimal_selection=%h",
                         optimal_selection);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimal_selection=%h",
                         expected_optimal_selection);
                $display("  Got:      optimal_selection=%h",
                         optimal_selection);
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
