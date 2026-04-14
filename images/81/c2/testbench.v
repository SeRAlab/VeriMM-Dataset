`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CCLK;
    reg [31:0] instr;
    reg rst;
    wire [7:0] IF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CCLK(CCLK),
        .instr(instr),
        .rst(rst),
        .IF(IF)
    );
    task perform_reset;

        begin
            rst = 1;
            instr = 32'h0;
            @(posedge CCLK);
            #1 rst = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        perform_reset();
        instr = 32'h00000000;
        @(posedge CCLK);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        perform_reset();

        instr = {6'h23, 5'd1, 5'd2, 16'h0004};
        @(posedge CCLK);
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        perform_reset();

        instr = {6'h2B, 5'd1, 5'd2, 16'h0008};
        @(posedge CCLK);
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        perform_reset();

        instr = {6'h04, 5'd1, 5'd2, 16'h0001};
        @(posedge CCLK);
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        perform_reset();

        instr = {6'h02, 26'h000000F};
        @(posedge CCLK);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        perform_reset();

        instr = {6'h08, 5'd1, 5'd2, 16'hFFFF};
        @(posedge CCLK);
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        perform_reset();

        instr = {6'h0D, 5'd1, 5'd2, 16'hAAAA};
        @(posedge CCLK);
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        perform_reset();

        instr = 32'hFFFFFFFF;
        @(posedge CCLK);
        #1;

        check_outputs(8'h80);
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
        input [7:0] expected_IF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IF === (expected_IF ^ IF ^ expected_IF)) begin
                $display("PASS");
                $display("  Outputs: IF=%h",
                         IF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF=%h",
                         expected_IF);
                $display("  Got:      IF=%h",
                         IF);
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
