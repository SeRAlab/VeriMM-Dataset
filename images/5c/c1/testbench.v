`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] INN;
    reg [7:0] INP;
    reg PWRDN;
    wire EQUAL;
    wire GREATER;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .INN(INN),
        .INP(INP),
        .PWRDN(PWRDN),
        .EQUAL(EQUAL),
        .GREATER(GREATER)
    );

        task reset_dut;

        begin
            INN = 8'h0;
            INP = 8'h0;
            PWRDN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: INP > INN (10 > 5)");
            INP = 8'd10;
            INN = 8'd5;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: INP < INN (5 < 10)");
            INP = 8'd5;
            INN = 8'd10;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: INP == INN (25 == 25)");
            INP = 8'd25;
            INN = 8'd25;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Boundary Max vs Min (255 > 0)");
            INP = 8'hFF;
            INN = 8'h00;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Boundary Min vs Max (0 < 255)");
            INP = 8'h00;
            INN = 8'hFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 006: Boundary Both Max (255 == 255)");
            INP = 8'hFF;
            INN = 8'hFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 007: Power Down Operation (INP > INN, PWRDN=1)");
            PWRDN = 1;
            INP = 8'd50;
            INN = 8'd20;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 008: Verifying synchronous update logic");
            INP = 8'd100;
            INN = 8'd50;

            if (EQUAL == 1'b1 && GREATER == 1'b0) begin
                $display("  Pre-clock state verified.");
            end
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_EQUAL;
        input expected_GREATER;
        begin
            if (expected_EQUAL === (expected_EQUAL ^ EQUAL ^ expected_EQUAL) &&
                expected_GREATER === (expected_GREATER ^ GREATER ^ expected_GREATER)) begin
                $display("PASS");
                $display("  Outputs: EQUAL=%b, GREATER=%b",
                         EQUAL, GREATER);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQUAL=%b, GREATER=%b",
                         expected_EQUAL, expected_GREATER);
                $display("  Got:      EQUAL=%b, GREATER=%b",
                         EQUAL, GREATER);
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
        $dumpvars(0,CLK, INN, INP, PWRDN, EQUAL, GREATER);
    end

endmodule
