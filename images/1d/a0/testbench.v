`timescale 1ns/1ps

module dwt_hair_transform_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    wire [7:0] avg;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_hair_transform dut (
        .x0(x0),
        .x1(x1),
        .avg(avg),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Zero Inputs", test_num);
        x0 = 8'd0;
        x1 = 8'd0;

        #1;


        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Maximum Inputs", test_num);
        x0 = 8'd255;
        x1 = 8'd255;

        #1;


        check_outputs(8'd255, 8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Positive Difference (Even Sum)", test_num);
        x0 = 8'd100;
        x1 = 8'd50;

        #1;


        check_outputs(8'd75, 8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Negative Difference (Wrap-around)", test_num);
        x0 = 8'd40;
        x1 = 8'd60;

        #1;


        check_outputs(8'd50, 8'hEC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Odd Sum Truncation", test_num);
        x0 = 8'd10;
        x1 = 8'd11;

        #1;


        check_outputs(8'd10, 8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Large Difference", test_num);
        x0 = 8'd200;
        x1 = 8'd10;

        #1;


        check_outputs(8'd105, 8'hBE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Power of Two Values", test_num);
        x0 = 8'd128;
        x1 = 8'd64;

        #1;


        check_outputs(8'd96, 8'd64);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_hair_transform Testbench");
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
        input [7:0] expected_avg;
        input [7:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_avg === (expected_avg ^ avg ^ expected_avg) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: avg=%h, diff=%h",
                         avg, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avg=%h, diff=%h",
                         expected_avg, expected_diff);
                $display("  Got:      avg=%h, diff=%h",
                         avg, diff);
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
