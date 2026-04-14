`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] WD;
    reg [15:0] address;
    reg clk;
    reg mR;
    reg mW;
    wire [15:0] RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WD(WD),
        .address(address),
        .clk(clk),
        .mR(mR),
        .mW(mW),
        .RD(RD)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write 0xAAAA to Address 0x0001", test_num);

            @(negedge clk);
            mW = 1; mR = 1; address = 16'h0001; WD = 16'hAAAA;
            @(negedge clk);
            mW = 0;


            @(posedge clk);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Write 0x5555 to Address 0x000F", test_num);
            @(negedge clk);
            mW = 1; address = 16'h000F; WD = 16'h5555;
            @(negedge clk);
            mW = 0;
            @(posedge clk);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify persistence at Address 0x0001", test_num);
            @(negedge clk);
            mW = 0; mR = 1; address = 16'h0001;
            @(posedge clk);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overwrite Address 0x0001 with 0x1234", test_num);
            @(negedge clk);
            mW = 1; address = 16'h0001; WD = 16'h1234;
            @(negedge clk);
            mW = 0;
            @(posedge clk);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Ensure no write occurs when mW is low", test_num);

            @(negedge clk);
            mW = 0; address = 16'h000F; WD = 16'hFFFF;
            @(negedge clk);


            @(posedge clk);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_RD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RD === (expected_RD ^ RD ^ expected_RD)) begin
                $display("PASS");
                $display("  Outputs: RD=%h",
                         RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h",
                         expected_RD);
                $display("  Got:      RD=%h",
                         RD);
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
