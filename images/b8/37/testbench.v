`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EW_VEHICLE_DETECT;
    reg NS_VEHICLE_DETECT;
    reg [3:0] ewCounter;
    reg [4:0] nsCounter;
    reg [1:0] yellowCounter;
    wire EW_GREEN;
    wire EW_RED;
    wire EW_YELLOW;
    wire NS_GREEN;
    wire NS_RED;
    wire NS_YELLOW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EW_VEHICLE_DETECT(EW_VEHICLE_DETECT),
        .NS_VEHICLE_DETECT(NS_VEHICLE_DETECT),
        .ewCounter(ewCounter),
        .nsCounter(nsCounter),
        .yellowCounter(yellowCounter),
        .EW_GREEN(EW_GREEN),
        .EW_RED(EW_RED),
        .EW_YELLOW(EW_YELLOW),
        .NS_GREEN(NS_GREEN),
        .NS_RED(NS_RED),
        .NS_YELLOW(NS_YELLOW)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: NS Green Phase", test_num);
            nsCounter = 5'd15;
            ewCounter = 4'd0;
            yellowCounter = 2'd0;
            NS_VEHICLE_DETECT = 1'b1;
            EW_VEHICLE_DETECT = 1'b0;

            #1;


            check_outputs(0, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: NS Yellow Phase", test_num);
            nsCounter = 5'd0;
            ewCounter = 4'd0;
            yellowCounter = 2'd2;
            NS_VEHICLE_DETECT = 1'b0;
            EW_VEHICLE_DETECT = 1'b1;

            #1;


            check_outputs(0, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: EW Green Phase", test_num);
            nsCounter = 5'd0;
            ewCounter = 4'd10;
            yellowCounter = 2'd0;
            NS_VEHICLE_DETECT = 1'b0;
            EW_VEHICLE_DETECT = 1'b1;

            #1;


            check_outputs(1, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: EW Yellow Phase", test_num);
            nsCounter = 5'd0;
            ewCounter = 4'd0;
            yellowCounter = 2'd2;
            NS_VEHICLE_DETECT = 1'b1;
            EW_VEHICLE_DETECT = 1'b0;

            #1;


            check_outputs(0, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: NS Green (Low Counter)", test_num);
            nsCounter = 5'd1;
            ewCounter = 4'd0;
            yellowCounter = 2'd0;
            NS_VEHICLE_DETECT = 1'b1;
            EW_VEHICLE_DETECT = 1'b1;

            #1;


            check_outputs(0, 1, 0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Default/Start State", test_num);
            nsCounter = 5'd0;
            ewCounter = 4'd0;
            yellowCounter = 2'd0;
            NS_VEHICLE_DETECT = 1'b0;
            EW_VE_HICLE_DETECT = 1'b0;

            #1;


            check_outputs(0, 1, 0, 1, 0, 0);
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
        input expected_EW_GREEN;
        input expected_EW_RED;
        input expected_EW_YELLOW;
        input expected_NS_GREEN;
        input expected_NS_RED;
        input expected_NS_YELLOW;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EW_GREEN === (expected_EW_GREEN ^ EW_GREEN ^ expected_EW_GREEN) &&
                expected_EW_RED === (expected_EW_RED ^ EW_RED ^ expected_EW_RED) &&
                expected_EW_YELLOW === (expected_EW_YELLOW ^ EW_YELLOW ^ expected_EW_YELLOW) &&
                expected_NS_GREEN === (expected_NS_GREEN ^ NS_GREEN ^ expected_NS_GREEN) &&
                expected_NS_RED === (expected_NS_RED ^ NS_RED ^ expected_NS_RED) &&
                expected_NS_YELLOW === (expected_NS_YELLOW ^ NS_YELLOW ^ expected_NS_YELLOW)) begin
                $display("PASS");
                $display("  Outputs: EW_GREEN=%b, EW_RED=%b, EW_YELLOW=%b, NS_GREEN=%b, NS_RED=%b, NS_YELLOW=%b",
                         EW_GREEN, EW_RED, EW_YELLOW, NS_GREEN, NS_RED, NS_YELLOW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EW_GREEN=%b, EW_RED=%b, EW_YELLOW=%b, NS_GREEN=%b, NS_RED=%b, NS_YELLOW=%b",
                         expected_EW_GREEN, expected_EW_RED, expected_EW_YELLOW, expected_NS_GREEN, expected_NS_RED, expected_NS_YELLOW);
                $display("  Got:      EW_GREEN=%b, EW_RED=%b, EW_YELLOW=%b, NS_GREEN=%b, NS_RED=%b, NS_YELLOW=%b",
                         EW_GREEN, EW_RED, EW_YELLOW, NS_GREEN, NS_RED, NS_YELLOW);
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
