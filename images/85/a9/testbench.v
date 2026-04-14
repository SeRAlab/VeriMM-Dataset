`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] length;
    reg [7:0] width;
    wire [15:0] area;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .length(length),
        .width(width),
        .area(area)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero inputs (0x0)", test_num);
        length = 8'h00;
        width = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Zero length (0 * 255)", test_num);
        length = 8'h00;
        width = 8'hFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Zero width (255 * 0)", test_num);
        length = 8'hFF;
        width = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Unit area (1 * 1)", test_num);
        length = 8'h01;
        width = 8'h01;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Typical small values (10 * 20)", test_num);
        length = 8'd10;
        width = 8'd20;
        #1;

        check_outputs(16'd200);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Square value (15 * 15)", test_num);
        length = 8'd15;
        width = 8'd15;
        #1;

        check_outputs(16'd225);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Boundary of 8-bit result (16 * 16)", test_num);
        length = 8'd16;
        width = 8'd16;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large values (128 * 128)", test_num);
        length = 8'd128;
        width = 8'd128;
        #1;

        check_outputs(16'd16384);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Maximum possible inputs (255 * 255)", test_num);
        length = 8'hFF;
        width = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Random prime product (13 * 17)", test_num);
        length = 8'd13;
        width = 8'd17;
        #1;

        check_outputs(16'd221);
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
        input [15:0] expected_area;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_area === (expected_area ^ area ^ expected_area)) begin
                $display("PASS");
                $display("  Outputs: area=%h",
                         area);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: area=%h",
                         expected_area);
                $display("  Got:      area=%h",
                         area);
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
