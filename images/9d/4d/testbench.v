`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] bm1;
    reg [1:0] bm2;
    reg [3:0] pm1;
    reg [3:0] pm2;
    wire d;
    wire [3:0] npm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bm1(bm1),
        .bm2(bm2),
        .pm1(pm1),
        .pm2(pm2),
        .d(d),
        .npm(npm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            pm1 = 4'd2; bm1 = 2'd1;
            pm2 = 4'd5; bm2 = 2'd2;
            #1;

            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            pm1 = 4'd8; bm1 = 2'd2;
            pm2 = 4'd4; bm2 = 2'd1;
            #1;

            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            pm1 = 4'd15; bm1 = 2'd2;
            pm2 = 4'd10; bm2 = 2'd1;
            #1;

            check_outputs(1'b1, 4'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            pm1 = 4'd10; bm1 = 2'd1;
            pm2 = 4'd15; bm2 = 2'd3;
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            pm1 = 4'd5; bm1 = 2'd1;
            pm2 = 4'd4; bm2 = 2'd2;
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            pm1 = 4'd14; bm1 = 2'd3;
            pm2 = 4'd15; bm2 = 2'd1;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            pm1 = 4'd0; bm1 = 2'd0;
            pm2 = 4'd0; bm2 = 2'd0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            pm1 = 4'd13; bm1 = 2'd1;
            pm2 = 4'd14; bm2 = 2'd2;
            #1;

            check_outputs(1'b0, 4'd14);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            pm1 = 4'd14; bm1 = 2'd2;
            pm2 = 4'd13; bm2 = 2'd1;
            #1;

            check_outputs(1'b1, 4'd14);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            pm1 = 4'd15; bm1 = 2'd3;
            pm2 = 4'd15; bm2 = 2'd3;
            #1;

            check_outputs(1'b0, 4'd15);
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
        input expected_d;
        input [3:0] expected_npm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_npm === (expected_npm ^ npm ^ expected_npm)) begin
                $display("PASS");
                $display("  Outputs: d=%b, npm=%h",
                         d, npm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%b, npm=%h",
                         expected_d, expected_npm);
                $display("  Got:      d=%b, npm=%h",
                         d, npm);
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
