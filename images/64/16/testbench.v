`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] lb;
    reg [31:0] lbu;
    reg [31:0] lh;
    reg [31:0] lhu;
    reg [2:0] load_option;
    reg [31:0] lw;
    wire [31:0] ext_Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lb(lb),
        .lbu(lbu),
        .lh(lh),
        .lhu(lhu),
        .load_option(load_option),
        .lw(lw),
        .ext_Dout(ext_Dout)
    );
    task init_inputs;

        begin
            lw  = 32'hAAAAAAAA;
            lb  = 32'hBBBBBBBB;
            lbu = 32'hCCCCCCCC;
            lh  = 32'hDDDDDDDD;
            lhu = 32'hEEEEEEEE;
            load_option = 3'b000;
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Select lw (load_option = 000)");
            init_inputs();
            lw = 32'h12345678;
            load_option = 3'b000;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Select lb (load_option = 101)");
            init_inputs();
            lb = 32'hDEADBEEF;
            load_option = 3'b101;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Select lbu (load_option = 001)");
            init_inputs();
            lbu = 32'h5555AAAA;
            load_option = 3'b001;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Select lh (load_option = 111)");
            init_inputs();
            lh = 32'h87654321;
            load_option = 3'b111;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Select lhu (load_option = 011)");
            init_inputs();
            lhu = 32'h00FF00FF;
            load_option = 3'b011;
            #1;

            check_outputs(32'h00FF00FF);
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
        input [31:0] expected_ext_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ext_Dout === (expected_ext_Dout ^ ext_Dout ^ expected_ext_Dout)) begin
                $display("PASS");
                $display("  Outputs: ext_Dout=%h",
                         ext_Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ext_Dout=%h",
                         expected_ext_Dout);
                $display("  Got:      ext_Dout=%h",
                         ext_Dout);
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
