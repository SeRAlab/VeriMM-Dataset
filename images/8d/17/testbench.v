`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cx_zero;
    reg ext_int;
    reg [6:0] opcode;
    reg [1:0] prefix;
    reg zf;
    wire next_in_exec;
    wire next_in_opco;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cx_zero(cx_zero),
        .ext_int(ext_int),
        .opcode(opcode),
        .prefix(prefix),
        .zf(zf),
        .next_in_exec(next_in_exec),
        .next_in_opco(next_in_opco)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs zero", test_num);
            prefix = 2'b00;
            opcode = 7'b0000000;
            cx_zero = 0;
            zf = 0;
            ext_int = 0;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: External Interrupt high", test_num);
            prefix = 2'b00;
            opcode = 7'b1010101;
            cx_zero = 0;
            zf = 0;
            ext_int = 1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Prefix active", test_num);
            prefix = 2'b01;
            opcode = 7'b0000000;
            cx_zero = 0;
            zf = 0;
            ext_int = 0;

            #1;


            check_outputs(1'b0, 1'b1);

            test_num = test_num + 1;
            prefix = 2'b10;
            $display("Testcase %0d: Alternative prefix active", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Branch flags high", test_num);
            prefix = 2'b00;
            opcode = 7'b1110000;
            cx_zero = 1;
            zf = 1;
            ext_int = 0;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Opcode boundary check (0x7F)", test_num);
            prefix = 2'b00;
            opcode = 7'b1111111;
            cx_zero = 0;
            zf = 0;
            ext_int = 0;
            #1;

            check_outputs(1'b1, 1'b0);

            test_num = test_num + 1;
            $display("Testcase %0d: Opcode boundary check (0x40)", test_num);
            opcode = 7'b1000000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Combined Prefix and Interrupt", test_num);
            prefix = 2'b11;
            opcode = 7'b0101010;
            cx_zero = 1;
            zf = 0;
            ext_int = 1;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_next_in_exec;
        input expected_next_in_opco;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_in_exec === (expected_next_in_exec ^ next_in_exec ^ expected_next_in_exec) &&
                expected_next_in_opco === (expected_next_in_opco ^ next_in_opco ^ expected_next_in_opco)) begin
                $display("PASS");
                $display("  Outputs: next_in_exec=%b, next_in_opco=%b",
                         next_in_exec, next_in_opco);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_in_exec=%b, next_in_opco=%b",
                         expected_next_in_exec, expected_next_in_opco);
                $display("  Got:      next_in_exec=%b, next_in_opco=%b",
                         next_in_exec, next_in_opco);
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
