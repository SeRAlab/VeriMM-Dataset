`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] alu_in1;
    reg [31:0] alu_in2;
    reg [2:0] op_code;
    wire [31:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_in1(alu_in1),
        .alu_in2(alu_in2),
        .op_code(op_code),
        .alu_out(alu_out)
    );
    task testcase001;

    begin
        test_num = 1;
        op_code = 3'b000;
        alu_in1 = 32'sd15;
        alu_in2 = 32'sd25;
        #1;

        check_outputs(32'sd40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        op_code = 3'b000;
        alu_in1 = -32'sd10;
        alu_in2 = 32'sd30;
        #1;

        check_outputs(32'sd20);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        op_code = 3'b001;
        alu_in1 = 32'sd6;
        alu_in2 = 32'sd7;
        #1;

        check_outputs(32'sd42);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        op_code = 3'b001;
        alu_in1 = -32'sd5;
        alu_in2 = 32'sd8;
        #1;

        check_outputs(-32'sd40);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        op_code = 3'b010;
        alu_in1 = 32'hAAAAAAAA;
        alu_in2 = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        op_code = 3'b011;
        alu_in1 = 32'h0;
        alu_in2 = 32'hDEADBEEF;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        op_code = 3'b100;
        alu_in1 = 32'h12345678;
        alu_in2 = 32'h0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        op_code = 3'b111;
        alu_in1 = 32'hFFFFFFFF;
        alu_in2 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        op_code = 3'b000;
        alu_in1 = 32'h7FFFFFFF;
        alu_in2 = 32'h00000001;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        op_code = 3'b001;
        alu_in1 = 32'sd999;
        alu_in2 = 32'sd0;
        #1;

        check_outputs(32'sd0);
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
        input [31:0] expected_alu_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
