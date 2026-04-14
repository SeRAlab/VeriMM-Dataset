`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pc;
    wire [5:0] text_mem_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .text_mem_addr(text_mem_addr)
    );
    task testcase001;

    begin
        test_num = 1;
        pc = 8'b00000000;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pc = 8'b11111111;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pc = 8'b00000011;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pc = 8'b00000100;
        #1;

        check_outputs(6'b000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pc = 8'b10101010;
        #1;

        check_outputs(6'b101010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pc = 8'b01010101;
        #1;

        check_outputs(6'b010101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pc = 8'b11000000;
        #1;

        check_outputs(6'b110000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pc = 8'hD2;
        #1;

        check_outputs(6'b110100);
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
        input [5:0] expected_text_mem_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_text_mem_addr === (expected_text_mem_addr ^ text_mem_addr ^ expected_text_mem_addr)) begin
                $display("PASS");
                $display("  Outputs: text_mem_addr=%h",
                         text_mem_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: text_mem_addr=%h",
                         expected_text_mem_addr);
                $display("  Got:      text_mem_addr=%h",
                         text_mem_addr);
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
