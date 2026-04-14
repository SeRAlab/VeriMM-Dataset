`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data1;
    reg data2;
    reg data3;
    reg data4;
    reg data5;
    reg data6;
    reg data7;
    reg data8;
    reg [2:0] seleksioni;
    wire dalja;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .data6(data6),
        .data7(data7),
        .data8(data8),
        .seleksioni(seleksioni),
        .dalja(dalja)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select data1 (Value: 1)", test_num);
        seleksioni = 3'b000;
        data1 = 1'b1; data2 = 1'b0; data3 = 1'b0; data4 = 1'b0;
        data5 = 1'b0; data6 = 1'b0; data7 = 1'b0; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select data1 (Value: 0)", test_num);
        seleksioni = 3'b000;
        data1 = 1'b0; data2 = 1'b1; data3 = 1'b1; data4 = 1'b1;
        data5 = 1'b1; data6 = 1'b1; data7 = 1'b1; data8 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select data2 (Value: 1)", test_num);
        seleksioni = 3'b001;
        data1 = 1'b0; data2 = 1'b1; data3 = 1'b0; data4 = 1'b0;
        data5 = 1'b0; data6 = 1'b0; data7 = 1'b0; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select data3 (Value: 1)", test_num);
        seleksioni = 3'b010;
        data1 = 1'b0; data2 = 1'b0; data3 = 1'b1; data4 = 1'b0;
        data5 = 1'b0; data6 = 1'b0; data7 = 1'b0; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select data4 (Value: 1)", test_num);
        seleksioni = 3'b011;
        data1 = 1'b0; data2 = 1'b0; data3 = 1'b0; data4 = 1'b1;
        data5 = 1'b0; data6 = 1'b0; data7 = 1'b0; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select data5 (Value: 1)", test_num);
        seleksioni = 3'b100;
        data1 = 1'b0; data2 = 1'b0; data3 = 1'b0; data4 = 1'b0;
        data5 = 1'b1; data6 = 1'b0; data7 = 1'b0; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select data6 (Value: 1)", test_num);
        seleksioni = 3'b101;
        data1 = 1'b0; data2 = 1'b0; data3 = 1'b0; data4 = 1'b0;
        data5 = 1'b0; data6 = 1'b1; data7 = 1'b0; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Select data7 (Value: 1)", test_num);
        seleksioni = 3'b110;
        data1 = 1'b0; data2 = 1'b0; data3 = 1'b0; data4 = 1'b0;
        data5 = 1'b0; data6 = 1'b0; data7 = 1'b1; data8 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Select data8 (Value: 1)", test_num);
        seleksioni = 3'b111;
        data1 = 1'b0; data2 = 1'b0; data3 = 1'b0; data4 = 1'b0;
        data5 = 1'b0; data6 = 1'b0; data7 = 1'b0; data8 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Select data8 (Value: 0)", test_num);
        seleksioni = 3'b111;
        data1 = 1'b1; data2 = 1'b1; data3 = 1'b1; data4 = 1'b1;
        data5 = 1'b1; data6 = 1'b1; data7 = 1'b1; data8 = 1'b0;
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
        input expected_dalja;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dalja === (expected_dalja ^ dalja ^ expected_dalja)) begin
                $display("PASS");
                $display("  Outputs: dalja=%b",
                         dalja);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dalja=%b",
                         expected_dalja);
                $display("  Got:      dalja=%b",
                         dalja);
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
