`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] i_aluop;
    reg [5:0] i_funct;
    wire [3:0] o_alucontrol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_aluop(i_aluop),
        .i_funct(i_funct),
        .o_alucontrol(o_alucontrol)
    );
    task testcase001;

    begin
        test_num = 1;
        i_aluop = 2'b00;
        i_funct = 6'b000000;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i_aluop = 2'b01;
        i_funct = 6'b000000;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i_aluop = 2'b10;
        i_funct = 6'd32;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i_aluop = 2'b10;
        i_funct = 6'd34;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i_aluop = 2'b10;
        i_funct = 6'd36;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i_aluop = 2'b10;
        i_funct = 6'd37;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i_aluop = 2'b10;
        i_funct = 6'd42;
        #1;

        check_outputs(4'b0111);
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
        input [3:0] expected_o_alucontrol;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_alucontrol === (expected_o_alucontrol ^ o_alucontrol ^ expected_o_alucontrol)) begin
                $display("PASS");
                $display("  Outputs: o_alucontrol=%h",
                         o_alucontrol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_alucontrol=%h",
                         expected_o_alucontrol);
                $display("  Got:      o_alucontrol=%h",
                         o_alucontrol);
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
