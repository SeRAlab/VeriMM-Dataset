`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg en;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .en(en),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Disabled state (en=0, a=3'b000)", test_num);
        en = 0;
        a = 3'b000;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enabled, input 0 (en=1, a=3'b000)", test_num);
        en = 1;
        a = 3'b000;
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Enabled, input 1 (en=1, a=3'b001)", test_num);
        en = 1;
        a = 3'b001;
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enabled, input 2 (en=1, a=3'b010)", test_num);
        en = 1;
        a = 3'b010;
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enabled, input 3 (en=1, a=3'b011)", test_num);
        en = 1;
        a = 3'b011;
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Enabled, input 4 (en=1, a=3'b100)", test_num);
        en = 1;
        a = 3'b100;
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Enabled, input 5 (en=1, a=3'b101)", test_num);
        en = 1;
        a = 3'b101;
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Enabled, input 6 (en=1, a=3'b110)", test_num);
        en = 1;
        a = 3'b110;
        #1;

        check_outputs(8'b01000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Enabled, input 7 (en=1, a=3'b111)", test_num);
        en = 1;
        a = 3'b111;
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Disabled state with high input (en=0, a=3'b111)", test_num);
        en = 0;
        a = 3'b111;
        #1;

        check_outputs(8'b00000000);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
