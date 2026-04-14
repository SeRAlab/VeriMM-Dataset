`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] asset_a;
    reg [4:0] asset_b;
    reg [4:0] asset_c;
    reg [4:0] asset_d;
    reg [4:0] asset_e;
    wire [4:0] allocation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset_a(asset_a),
        .asset_b(asset_b),
        .asset_c(asset_c),
        .asset_d(asset_d),
        .asset_e(asset_e),
        .allocation(allocation)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asset A has highest return", test_num);
            asset_a = 5'd25;
            asset_b = 5'd10;
            asset_c = 5'd5;
            asset_d = 5'd15;
            asset_e = 5'd20;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asset B has highest return", test_num);
            asset_a = 5'd5;
            asset_b = 5'd30;
            asset_c = 5'd12;
            asset_d = 5'd2;
            asset_e = 5'd18;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asset C has highest return", test_num);
            asset_a = 5'd1;
            asset_b = 5'd2;
            asset_c = 5'd31;
            asset_d = 5'd4;
            asset_e = 5'd5;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asset D has highest return", test_num);
            asset_a = 5'd10;
            asset_b = 5'd10;
            asset_c = 5'd10;
            asset_d = 5'd20;
            asset_e = 5'd10;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asset E has highest return", test_num);
            asset_a = 5'd0;
            asset_b = 5'd0;
            asset_c = 5'd0;
            asset_d = 5'd0;
            asset_e = 5'd1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Tie between A and B (Priority to A)", test_num);
            asset_a = 5'd20;
            asset_b = 5'd20;
            asset_c = 5'd10;
            asset_d = 5'd5;
            asset_e = 5'd5;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Tie between D and E (Priority to D)", test_num);
            asset_a = 5'd5;
            asset_b = 5'd5;
            asset_c = 5'd5;
            asset_d = 5'd15;
            asset_e = 5'd15;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All assets equal (Priority to A)", test_num);
            asset_a = 5'd31;
            asset_b = 5'd31;
            asset_c = 5'd31;
            asset_d = 5'd31;
            asset_e = 5'd31;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All assets zero (Priority to A)", test_num);
            asset_a = 5'd0;
            asset_b = 5'd0;
            asset_c = 5'd0;
            asset_d = 5'd0;
            asset_e = 5'd0;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asset C is slightly higher than others", test_num);
            asset_a = 5'd14;
            asset_b = 5'd14;
            asset_c = 5'd15;
            asset_d = 5'd14;
            asset_e = 5'd14;
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
