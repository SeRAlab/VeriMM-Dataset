`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] count1;
    reg [3:0] count2;
    reg [3:0] count3;
    reg [3:0] count4;
    wire [3:0] sale1;
    wire [3:0] sale2;
    wire [3:0] sale3;
    wire [3:0] sale4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count1(count1),
        .count2(count2),
        .count3(count3),
        .count4(count4),
        .sale1(sale1),
        .sale2(sale2),
        .sale3(sale3),
        .sale4(sale4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            count1 = 4'd0; count2 = 4'd0; count3 = 4'd0; count4 = 4'd0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unit inputs", test_num);
            count1 = 4'd1; count2 = 4'd1; count3 = 4'd1; count4 = 4'd1;
            #1;

            check_outputs(4'hC, 4'hF, 4'h2, 4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max inputs (15)", test_num);
            count1 = 4'd15; count2 = 4'd15; count3 = 4'd15; count4 = 4'd15;
            #1;

            check_outputs(4'h4, 4'h1, 4'hE, 4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed intermediate values", test_num);
            count1 = 4'd2; count2 = 4'd4; count3 = 4'd5; count4 = 4'd9;
            #1;

            check_outputs(4'h8, 4'hC, 4'hA, 4'hB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary cases resulting in zero", test_num);
            count1 = 4'd4; count2 = 4'd0; count3 = 4'd8; count4 = 4'd0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_sale1;
        input [3:0] expected_sale2;
        input [3:0] expected_sale3;
        input [3:0] expected_sale4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sale1 === (expected_sale1 ^ sale1 ^ expected_sale1) &&
                expected_sale2 === (expected_sale2 ^ sale2 ^ expected_sale2) &&
                expected_sale3 === (expected_sale3 ^ sale3 ^ expected_sale3) &&
                expected_sale4 === (expected_sale4 ^ sale4 ^ expected_sale4)) begin
                $display("PASS");
                $display("  Outputs: sale1=%h, sale2=%h, sale3=%h, sale4=%h",
                         sale1, sale2, sale3, sale4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sale1=%h, sale2=%h, sale3=%h, sale4=%h",
                         expected_sale1, expected_sale2, expected_sale3, expected_sale4);
                $display("  Got:      sale1=%h, sale2=%h, sale3=%h, sale4=%h",
                         sale1, sale2, sale3, sale4);
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
