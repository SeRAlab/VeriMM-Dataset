`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] asset1;
    reg [7:0] asset2;
    reg [7:0] asset3;
    wire [1:0] selected_asset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .selected_asset(selected_asset)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Asset 1 is strictly maximum", test_num);
        asset1 = 8'd100;
        asset2 = 8'd50;
        asset3 = 8'd25;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Asset 2 is strictly maximum", test_num);
        asset1 = 8'd10;
        asset2 = 8'd200;
        asset3 = 8'd150;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Asset 3 is strictly maximum", test_num);
        asset1 = 8'd0;
        asset2 = 8'd128;
        asset3 = 8'd255;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Tie between Asset 1 and 2 (1 wins)", test_num);
        asset1 = 8'd150;
        asset2 = 8'd150;
        asset3 = 8'd100;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Tie between Asset 1 and 3 (1 wins)", test_num);
        asset1 = 8'd220;
        asset2 = 8'd180;
        asset3 = 8'd220;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Tie between Asset 2 and 3 (2 wins)", test_num);
        asset1 = 8'd40;
        asset2 = 8'd99;
        asset3 = 8'd99;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All assets equal (1 wins)", test_num);
        asset1 = 8'd75;
        asset2 = 8'd75;
        asset3 = 8'd75;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All values zero (1 wins)", test_num);
        asset1 = 8'd0;
        asset2 = 8'd0;
        asset3 = 8'd0;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max values check", test_num);
        asset1 = 8'hFF;
        asset2 = 8'hFE;
        asset3 = 8'hFF;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Asset 3 wins by 1 bit", test_num);
        asset1 = 8'd200;
        asset2 = 8'd200;
        asset3 = 8'd201;
        #1;

        check_outputs(2'd3);
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
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_selected_asset;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_selected_asset === (expected_selected_asset ^ selected_asset ^ expected_selected_asset)) begin
                $display("PASS");
                $display("  Outputs: selected_asset=%h",
                         selected_asset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected_asset=%h",
                         expected_selected_asset);
                $display("  Got:      selected_asset=%h",
                         selected_asset);
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
