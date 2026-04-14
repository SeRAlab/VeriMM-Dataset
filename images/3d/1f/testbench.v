`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] asset1_weight;
    reg [7:0] asset2_weight;
    reg [7:0] asset3_weight;
    wire [7:0] total_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1_weight(asset1_weight),
        .asset2_weight(asset2_weight),
        .asset3_weight(asset3_weight),
        .total_weight(total_weight)
    );
    task testcase001;

        begin
            $display("Testcase 001: Sum below 100 (10 + 20 + 30)");
            asset1_weight = 8'd10;
            asset2_weight = 8'd20;
            asset3_weight = 8'd30;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sum exactly 100 (30 + 30 + 40)");
            asset1_weight = 8'd30;
            asset2_weight = 8'd30;
            asset3_weight = 8'd40;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sum exceeding 100 (50 + 50 + 50)");
            asset1_weight = 8'd50;
            asset2_weight = 8'd50;
            asset3_weight = 8'd50;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All inputs zero");
            asset1_weight = 8'd0;
            asset2_weight = 8'd0;
            asset3_weight = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum input values (255 + 255 + 255)");
            asset1_weight = 8'd255;
            asset2_weight = 8'd255;
            asset3_weight = 8'd255;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Single input at 100");
            asset1_weight = 8'd100;
            asset2_weight = 8'd0;
            asset3_weight = 8'd0;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single input exceeds 100 (150 + 0 + 0)");
            asset1_weight = 8'd150;
            asset2_weight = 8'd0;
            asset3_weight = 8'd0;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Sum just over 100 (34 + 33 + 34)");
            asset1_weight = 8'd34;
            asset2_weight = 8'd33;
            asset3_weight = 8'd34;
            #1;

            check_outputs(8'd100);
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
        input [7:0] expected_total_weight;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_weight === (expected_total_weight ^ total_weight ^ expected_total_weight)) begin
                $display("PASS");
                $display("  Outputs: total_weight=%h",
                         total_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_weight=%h",
                         expected_total_weight);
                $display("  Got:      total_weight=%h",
                         total_weight);
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
