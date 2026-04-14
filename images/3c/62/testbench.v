`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] asset1_return;
    reg [7:0] asset1_risk;
    reg [7:0] asset2_return;
    reg [7:0] asset2_risk;
    reg [7:0] asset3_return;
    reg [7:0] asset3_risk;
    reg [7:0] asset4_return;
    reg [7:0] asset4_risk;
    reg [7:0] asset5_return;
    reg [7:0] asset5_risk;
    wire [7:0] weight1;
    wire [7:0] weight2;
    wire [7:0] weight3;
    wire [7:0] weight4;
    wire [7:0] weight5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1_return(asset1_return),
        .asset1_risk(asset1_risk),
        .asset2_return(asset2_return),
        .asset2_risk(asset2_risk),
        .asset3_return(asset3_return),
        .asset3_risk(asset3_risk),
        .asset4_return(asset4_return),
        .asset4_risk(asset4_risk),
        .asset5_return(asset5_return),
        .asset5_risk(asset5_risk),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .weight4(weight4),
        .weight5(weight5)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dominant Asset 1", test_num);
            asset1_return = 8'd100; asset1_risk = 8'd5;
            asset2_return = 8'd10;  asset2_risk = 8'd50;
            asset3_return = 8'd10;  asset3_risk = 8'd50;
            asset4_return = 8'd10;  asset4_risk = 8'd50;
            asset5_return = 8'd10;  asset5_risk = 8'd50;

            #1;


            check_outputs(8'h64, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical Assets", test_num);
            asset1_return = 8'd50; asset1_risk = 8'd20;
            asset2_return = 8'd50; asset2_risk = 8'd20;
            asset3_return = 8'd50; asset3_risk = 8'd20;
            asset4_return = 8'd50; asset4_risk = 8'd20;
            asset5_return = 8'd50; asset5_risk = 8'd20;

            #1;


            check_outputs(8'h14, 8'h14, 8'h14, 8'h14, 8'h14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Risk Selection (Asset 3)", test_num);
            asset1_return = 8'd40; asset1_risk = 8'd30;
            asset2_return = 8'd40; asset2_risk = 8'd30;
            asset3_return = 8'd40; asset3_risk = 8'd05;
            asset4_return = 8'd40; asset4_risk = 8'd30;
            asset5_return = 8'd40; asset5_risk = 8'd30;

            #1;


            check_outputs(8'h00, 8'h00, 8'h64, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Return Selection (Asset 5)", test_num);
            asset1_return = 8'd10; asset1_risk = 8'd15;
            asset2_return = 8'd20; asset2_risk = 8'd15;
            asset3_return = 8'd30; asset3_risk = 8'd15;
            asset4_return = 8'd40; asset4_risk = 8'd15;
            asset5_return = 8'd90; asset5_risk = 8'd15;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h64);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Risk Trade-off (Asset 2 best balance)", test_num);
            asset1_return = 8'd255; asset1_risk = 8'd255;
            asset2_return = 8'd50;  asset2_risk = 8'd10;
            asset3_return = 8'd10;  asset3_risk = 8'd200;
            asset4_return = 8'd10;  asset4_risk = 8'd200;
            asset5_return = 8'd10;  asset5_risk = 8'd200;

            #1;


            check_outputs(8'h00, 8'h64, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_weight1;
        input [7:0] expected_weight2;
        input [7:0] expected_weight3;
        input [7:0] expected_weight4;
        input [7:0] expected_weight5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight1 === (expected_weight1 ^ weight1 ^ expected_weight1) &&
                expected_weight2 === (expected_weight2 ^ weight2 ^ expected_weight2) &&
                expected_weight3 === (expected_weight3 ^ weight3 ^ expected_weight3) &&
                expected_weight4 === (expected_weight4 ^ weight4 ^ expected_weight4) &&
                expected_weight5 === (expected_weight5 ^ weight5 ^ expected_weight5)) begin
                $display("PASS");
                $display("  Outputs: weight1=%h, weight2=%h, weight3=%h, weight4=%h, weight5=%h",
                         weight1, weight2, weight3, weight4, weight5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight1=%h, weight2=%h, weight3=%h, weight4=%h, weight5=%h",
                         expected_weight1, expected_weight2, expected_weight3, expected_weight4, expected_weight5);
                $display("  Got:      weight1=%h, weight2=%h, weight3=%h, weight4=%h, weight5=%h",
                         weight1, weight2, weight3, weight4, weight5);
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
