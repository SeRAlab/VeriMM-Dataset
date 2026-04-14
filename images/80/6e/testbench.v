`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ALU_op;
    wire [2:0] ALU_ctr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_op(ALU_op),
        .ALU_ctr(ALU_ctr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0000;
        $display("Test %0d: Testing ADD (ALU_op=0000)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0001;
        $display("Test %0d: Testing SUB (ALU_op=0001)", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0010;
        $display("Test %0d: Testing AND (ALU_op=0010)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0011;
        $display("Test %0d: Testing OR (ALU_op=0011)", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0100;
        $display("Test %0d: Testing XOR (ALU_op=0100)", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0110;
        $display("Test %0d: Testing SLT (ALU_op=0110)", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0101;
        $display("Test %0d: Testing NOR (ALU_op=0101)", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        ALU_op = 4'b0111;
        $display("Test %0d: Testing SRL/SLL (ALU_op=0111)", test_num);
        #1;

        check_outputs(3'b101);
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
        input [2:0] expected_ALU_ctr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_ctr === (expected_ALU_ctr ^ ALU_ctr ^ expected_ALU_ctr)) begin
                $display("PASS");
                $display("  Outputs: ALU_ctr=%h",
                         ALU_ctr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_ctr=%h",
                         expected_ALU_ctr);
                $display("  Got:      ALU_ctr=%h",
                         ALU_ctr);
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
