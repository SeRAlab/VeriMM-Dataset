`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] alu_op;
    reg [5:0] funct;
    wire [2:0] select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .funct(funct),
        .select(select)
    );
    task testcase001;

    begin
        test_num = 1;
        alu_op = 2'b00;
        funct = 6'b000000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        alu_op = 2'b01;
        funct = 6'b000000;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        alu_op = 2'b10;
        funct = 6'b100000;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        alu_op = 2'b10;
        funct = 6'b100010;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        alu_op = 2'b10;
        funct = 6'b100100;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        alu_op = 2'b10;
        funct = 6'b100101;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        alu_op = 2'b10;
        funct = 6'b101010;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_select;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_select === (expected_select ^ select ^ expected_select)) begin
                $display("PASS");
                $display("  Outputs: select=%h",
                         select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: select=%h",
                         expected_select);
                $display("  Got:      select=%h",
                         select);
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
