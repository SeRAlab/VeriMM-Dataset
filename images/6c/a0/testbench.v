`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] RegDst;
    reg [4:0] rd_D;
    reg [4:0] rt_D;
    wire [4:0] WAG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegDst(RegDst),
        .rd_D(rd_D),
        .rt_D(rt_D),
        .WAG(WAG)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst=00 (Select rt_D)", test_num);
            RegDst = 2'b00;
            rt_D   = 5'd12;
            rd_D   = 5'd25;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst=01 (Select rd_D)", test_num);
            RegDst = 2'b01;
            rt_D   = 5'd12;
            rd_D   = 5'd25;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst=10 (Default to 31)", test_num);
            RegDst = 2'b10;
            rt_D   = 5'd12;
            rd_D   = 5'd25;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst=11 (Default to 31)", test_num);
            RegDst = 2'b11;
            rt_D   = 5'd0;
            rd_D   = 5'd0;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst=00 (Select rt_D with max value)", test_num);
            RegDst = 2'b00;
            rt_D   = 5'h1F;
            rd_D   = 5'h00;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: RegDst=01 (Select rd_D with zero value)", test_num);
            RegDst = 2'b01;
            rt_D   = 5'h1F;
            rd_D   = 5'h00;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_WAG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WAG === (expected_WAG ^ WAG ^ expected_WAG)) begin
                $display("PASS");
                $display("  Outputs: WAG=%h",
                         WAG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WAG=%h",
                         expected_WAG);
                $display("  Got:      WAG=%h",
                         WAG);
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
