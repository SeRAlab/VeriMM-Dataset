`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] asset1;
    reg [3:0] asset2;
    reg [3:0] asset3;
    wire [3:0] optimized_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .optimized_return(optimized_return)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
        $display("========================================");


        
        
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
        input [3:0] expected_optimized_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimized_return === (expected_optimized_return ^ optimized_return ^ expected_optimized_return)) begin
                $display("PASS");
                $display("  Outputs: optimized_return=%h",
                         optimized_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimized_return=%h",
                         expected_optimized_return);
                $display("  Got:      optimized_return=%h",
                         optimized_return);
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
