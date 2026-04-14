`timescale 1ns/1ps

module PortfolioOptimizer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] asset1;
    reg [7:0] asset2;
    reg [7:0] asset3;
    reg clk;
    reg rst;
    reg [7:0] threshold;
    wire optimal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PortfolioOptimizer dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .clk(clk),
        .rst(rst),
        .threshold(threshold),
        .optimal(optimal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            asset1 = 0;
            asset2 = 0;
            asset3 = 0;
            threshold = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Average exceeds threshold", test_num);
            asset1 = 8'd30;
            asset2 = 8'd60;
            asset3 = 8'd90;
            threshold = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Average below threshold", test_num);
            asset1 = 8'd10;
            asset2 = 8'd20;
            asset3 = 8'd30;
            threshold = 8'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Average equals threshold (Boundary)", test_num);
            asset1 = 8'd100;
            asset2 = 8'd100;
            asset3 = 8'd100;
            threshold = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            asset1 = 8'd0;
            asset2 = 8'd0;
            asset3 = 8'd0;
            threshold = 8'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values", test_num);
            asset1 = 8'hFF;
            asset2 = 8'hFF;
            asset3 = 8'hFF;
            threshold = 8'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Uneven division (Sum 100)", test_num);
            asset1 = 8'd33;
            asset2 = 8'd33;
            asset3 = 8'd34;
            threshold = 8'd33;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High returns, higher threshold", test_num);
            asset1 = 8'd200;
            asset2 = 8'd210;
            asset3 = 8'd220;
            threshold = 8'd230;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PortfolioOptimizer Testbench");
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
        input expected_optimal;
        begin
            if (expected_optimal === (expected_optimal ^ optimal ^ expected_optimal)) begin
                $display("PASS");
                $display("  Outputs: optimal=%b",
                         optimal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimal=%b",
                         expected_optimal);
                $display("  Got:      optimal=%b",
                         optimal);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,asset1, asset2, asset3, clk, rst, threshold, optimal);
    end

endmodule
