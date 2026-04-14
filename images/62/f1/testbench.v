`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_i;
    reg leftRight;
    reg [4:0] shamt;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i(data_i),
        .leftRight(leftRight),
        .shamt(shamt),
        .data_o(data_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Left shift by 16 bits (leftRight=0)", test_num);
        data_i = 32'h00000001;
        leftRight = 0;
        shamt = 5'd0;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Left shift by 16 bits with shamt value ignored", test_num);
        data_i = 32'hFFFFFFFF;
        leftRight = 0;
        shamt = 5'd15;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Right shift by 0 bits", test_num);
        data_i = 32'hABCDEF01;
        leftRight = 1;
        shamt = 5'd0;
        #1;

        check_outputs(32'hABCDEF01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Right shift by 1 bit", test_num);
        data_i = 32'h80000000;
        leftRight = 1;
        shamt = 5'd1;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Right shift by 16 bits", test_num);
        data_i = 32'h12345678;
        leftRight = 1;
        shamt = 5'd16;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Right shift by 31 bits", test_num);
        data_i = 32'h80000000;
        leftRight = 1;
        shamt = 5'd31;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Right shift by 8 bits with pattern", test_num);
        data_i = 32'hA5A5A5A5;
        leftRight = 1;
        shamt = 5'd8;
        #1;

        check_outputs(32'h00A5A5A5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Left shift with zero input", test_num);
        data_i = 32'h00000000;
        leftRight = 0;
        shamt = 5'd0;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
