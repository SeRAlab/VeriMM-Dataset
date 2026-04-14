`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] instr;
    wire [31:0] oinstr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instr(instr),
        .oinstr(oinstr)
    );
    task testcase001;

        begin
            test_num = 1;
            instr = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            instr = 16'h7FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            instr = 16'h8000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            instr = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            instr = 16'h1234;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            instr = 16'hA5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFA5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            instr = 16'h8001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF8001);
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
        input [31:0] expected_oinstr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oinstr === (expected_oinstr ^ oinstr ^ expected_oinstr)) begin
                $display("PASS");
                $display("  Outputs: oinstr=%h",
                         oinstr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oinstr=%h",
                         expected_oinstr);
                $display("  Got:      oinstr=%h",
                         oinstr);
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
