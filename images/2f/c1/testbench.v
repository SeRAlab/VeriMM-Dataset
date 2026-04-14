`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] returns_asset1;
    reg [15:0] returns_asset2;
    reg [15:0] returns_asset3;
    reg [15:0] risks_asset1;
    reg [15:0] risks_asset2;
    reg [15:0] risks_asset3;
    wire [7:0] weight_asset1;
    wire [7:0] weight_asset2;
    wire [7:0] weight_asset3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .returns_asset1(returns_asset1),
        .returns_asset2(returns_asset2),
        .returns_asset3(returns_asset3),
        .risks_asset1(risks_asset1),
        .risks_asset2(risks_asset2),
        .risks_asset3(risks_asset3),
        .weight_asset1(weight_asset1),
        .weight_asset2(weight_asset2),
        .weight_asset3(weight_asset3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asset 1 Dominance", test_num);
            returns_asset1 = 16'd500; risks_asset1 = 16'd10;
            returns_asset2 = 16'd50;  risks_asset2 = 16'd200;
            returns_asset3 = 16'd50;  risks_asset3 = 16'd200;

            #1;


            check_outputs(8'h64, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Asset 2 Dominance", test_num);
            returns_asset1 = 16'd100; risks_asset1 = 16'd100;
            returns_asset2 = 16'd800; risks_asset2 = 16'd5;
            returns_asset3 = 16'd100; risks_asset3 = 16'd100;

            #1;


            check_outputs(8'h00, 8'h64, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Asset 3 Dominance", test_num);
            returns_asset1 = 16'd10;  risks_asset1 = 16'd500;
            returns_asset2 = 16'd10;  risks_asset2 = 16'd500;
            returns_asset3 = 16'd1000; risks_asset3 = 16'd20;

            #1;


            check_outputs(8'h00, 8'h00, 8'h64);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Identical Assets (Equal Weights)", test_num);
            returns_asset1 = 16'd100; risks_asset1 = 16'd50;
            returns_asset2 = 16'd100; risks_asset2 = 16'd50;
            returns_asset3 = 16'd100; risks_asset3 = 16'd50;

            #1;


            check_outputs(8'h21, 8'h21, 8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High Risk Exclusion", test_num);
            returns_asset1 = 16'd300; risks_asset1 = 16'd20;
            returns_asset2 = 16'd300; risks_asset2 = 16'd20;
            returns_asset3 = 16'd10;  risks_asset3 = 16'd1000;

            #1;


            check_outputs(8'h32, 8'h32, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Return vs Risk Trade-off", test_num);

            returns_asset1 = 16'd1000; risks_asset1 = 16'd950;
            returns_asset2 = 16'd200;  risks_asset2 = 16'd50;
            returns_asset3 = 16'd50;   risks_asset3 = 16'd100;

            #1;


            check_outputs(8'h00, 8'h64, 8'h00);
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
        input [7:0] expected_weight_asset1;
        input [7:0] expected_weight_asset2;
        input [7:0] expected_weight_asset3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight_asset1 === (expected_weight_asset1 ^ weight_asset1 ^ expected_weight_asset1) &&
                expected_weight_asset2 === (expected_weight_asset2 ^ weight_asset2 ^ expected_weight_asset2) &&
                expected_weight_asset3 === (expected_weight_asset3 ^ weight_asset3 ^ expected_weight_asset3)) begin
                $display("PASS");
                $display("  Outputs: weight_asset1=%h, weight_asset2=%h, weight_asset3=%h",
                         weight_asset1, weight_asset2, weight_asset3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight_asset1=%h, weight_asset2=%h, weight_asset3=%h",
                         expected_weight_asset1, expected_weight_asset2, expected_weight_asset3);
                $display("  Got:      weight_asset1=%h, weight_asset2=%h, weight_asset3=%h",
                         weight_asset1, weight_asset2, weight_asset3);
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
