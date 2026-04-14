`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] asset1_return;
    reg [15:0] asset1_risk;
    reg [15:0] asset2_return;
    reg [15:0] asset2_risk;
    reg [15:0] asset3_return;
    reg [15:0] asset3_risk;
    reg clk;
    reg reset;
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
        .asset1_risk(asset1_risk),
        .asset2_return(asset2_return),
        .asset2_risk(asset2_risk),
        .asset3_return(asset3_return),
        .asset3_risk(asset3_risk),
        .clk(clk),
        .reset(reset),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            asset1_return = 0; asset1_risk = 0;
            asset2_return = 0; asset2_risk = 0;
            asset3_return = 0; asset3_risk = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Identical Assets");
            reset_dut();
            asset1_return = 16'h0100; asset1_risk = 16'h0010;
            asset2_return = 16'h0100; asset2_risk = 16'h0010;
            asset3_return = 16'h0100; asset3_risk = 16'h0010;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h5555, 16'h5555, 16'h5555);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Asset 1 Dominant");
            reset_dut();
            asset1_return = 16'h0500; asset1_risk = 16'h0001;
            asset2_return = 16'h0010; asset2_risk = 16'h0100;
            asset3_return = 16'h0010; asset3_risk = 16'h0100;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'hFBFF, 16'h0200, 16'h0200);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Asset 2 High Risk Penalty");
            reset_dut();
            asset1_return = 16'h0200; asset1_risk = 16'h0020;
            asset2_return = 16'h0200; asset2_risk = 16'hFFFF;
            asset3_return = 16'h0200; asset3_risk = 16'h0020;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h7FFF, 16'h0001, 16'h7FFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Zero Returns");
            reset_dut();
            asset1_return = 16'h0000; asset1_risk = 16'h0010;
            asset2_return = 16'h0000; asset2_risk = 16'h0010;
            asset3_return = 16'h0000; asset3_risk = 16'h0010;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h5555, 16'h5555, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Graduated Returns");
            reset_dut();
            asset1_return = 16'h0100; asset1_risk = 16'h0010;
            asset2_return = 16'h0200; asset2_risk = 16'h0010;
            asset3_return = 16'h0300; asset3_risk = 16'h0010;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h2AAA, 16'h5555, 16'h8000);
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
        input [15:0] expected_weight1;
        input [15:0] expected_weight2;
        input [15:0] expected_weight3;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,asset1_return, asset1_risk, asset2_return, asset2_risk, asset3_return, asset3_risk, clk, reset, weight1, weight2, weight3);
    end

endmodule
