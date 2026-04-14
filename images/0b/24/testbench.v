`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] asset1_return;
    reg [15:0] asset2_return;
    reg [15:0] asset3_return;
    reg [15:0] target_return;
    wire [15:0] weight1;
    wire [15:0] weight2;
    wire [15:0] weight3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1_return(asset1_return),
        .asset2_return(asset2_return),
        .asset3_return(asset3_return),
        .target_return(target_return),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Uniform returns (10, 10, 10), Target = 10");
        asset1_return = 16'd10;
        asset2_return = 16'd10;
        asset3_return = 16'd10;
        target_return = 16'd10;


        #1;



        check_outputs(16'h5555, 16'h5555, 16'h5555);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Linear spread (10, 20, 30), Target = 20");
        asset1_return = 16'd10;
        asset2_return = 16'd20;
        asset3_return = 16'd30;
        target_return = 16'd20;

        #1;


        check_outputs(16'h5555, 16'h5555, 16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Linear spread (10, 20, 30), Target = 25");
        asset1_return = 16'd10;
        asset2_return = 16'd20;
        asset3_return = 16'd30;
        target_return = 16'd25;

        #1;


        check_outputs(16'h1555, 16'h5555, 16'h9555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Linear spread (10, 20, 30), Target = 15");
        asset1_return = 16'd10;
        asset2_return = 16'd20;
        asset3_return = 16'd30;
        target_return = 16'd15;
        #1;

        check_outputs(16'h9555, 16'h5555, 16'h1555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Boundary - Target return equals max asset return");
        asset1_return = 16'd10;
        asset2_return = 16'd20;
        asset3_return = 16'd30;
        target_return = 16'd30;

        #1;


        check_outputs(16'h0000, 16'h0000, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Boundary - Target return equals min asset return");
        asset1_return = 16'd10;
        asset2_return = 16'd20;
        asset3_return = 16'd30;
        target_return = 16'd10;

        #1;


        check_outputs(16'hFFFF, 16'h0000, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Two identical assets (10, 10, 40), Target = 20");
        asset1_return = 16'd10;
        asset2_return = 16'd10;
        asset3_return = 16'd40;
        target_return = 16'd20;

        #1;


        check_outputs(16'h5555, 16'h5555, 16'h5555);
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
        input [15:0] expected_weight1;
        input [15:0] expected_weight2;
        input [15:0] expected_weight3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight1 === (expected_weight1 ^ weight1 ^ expected_weight1) &&
                expected_weight2 === (expected_weight2 ^ weight2 ^ expected_weight2) &&
                expected_weight3 === (expected_weight3 ^ weight3 ^ expected_weight3)) begin
                $display("PASS");
                $display("  Outputs: weight1=%h, weight2=%h, weight3=%h",
                         weight1, weight2, weight3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight1=%h, weight2=%h, weight3=%h",
                         expected_weight1, expected_weight2, expected_weight3);
                $display("  Got:      weight1=%h, weight2=%h, weight3=%h",
                         weight1, weight2, weight3);
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
