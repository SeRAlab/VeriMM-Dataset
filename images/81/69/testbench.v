`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [3:0] data;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data(data),
        .seg(seg)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        ctrl = 2'b00;
        data = 4'b0000;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Data bits all high, ctrl zero", test_num);
        ctrl = 2'b00;
        data = 4'b1111;
        #1;

        check_outputs(7'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Ctrl bit 0 high, data zero", test_num);
        ctrl = 2'b01;
        data = 4'b0000;
        #1;

        check_outputs(7'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Ctrl bit 1 high, data zero", test_num);
        ctrl = 2'b10;
        data = 4'b0000;
        #1;

        check_outputs(7'h20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Both Ctrl bits high, data zero", test_num);
        ctrl = 2'b11;
        data = 4'b0000;
        #1;

        check_outputs(7'h30);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Ctrl bit 0 high, data 1010 (A)", test_num);
        ctrl = 2'b01;
        data = 4'b1010;
        #1;

        check_outputs(7'h1A);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Ctrl bit 1 high, data 0101 (5)", test_num);
        ctrl = 2'b10;
        data = 4'b0101;
        #1;

        check_outputs(7'h25);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Max data and max control", test_num);
        ctrl = 2'b11;
        data = 4'b1111;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Ctrl zero, data 0110 (6)", test_num);
        ctrl = 2'b00;
        data = 4'b0110;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Ctrl max, data 1001 (9)", test_num);
        ctrl = 2'b11;
        data = 4'b1001;
        #1;

        check_outputs(7'h39);
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
