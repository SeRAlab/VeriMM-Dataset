`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [4:0] o_verilog;
    reg [4:0] o_vhdl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .o_verilog(o_verilog),
        .o_vhdl(o_vhdl)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change 'a' at t=5 (ena=LOW) with mismatch", test_num);
            a = 16'h1111;
            o_vhdl = 5'b00001;
            o_verilog = 5'b00010;
            #5;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change 'a' at t=15 (ena=HIGH) with matching outputs", test_num);
            #10;
            a = 16'h2222;
            o_vhdl = 5'b10101;
            o_verilog = 5'b10101;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change 'a' at t=20 (ena=HIGH) with mismatch (Expect Error Msg)", test_num);
            #5;
            a = 16'h3333;
            o_vhdl = 5'b11111;
            o_verilog = 5'b00000;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change outputs while 'a' is static (Expect No Msg)", test_num);
            #5;
            o_vhdl = 5'b10110;
            o_verilog = 5'b01001;

            #1;


            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change 'a' and outputs simultaneously (Expect Error Msg)", test_num);
            #5;
            a = 16'hFFFF;
            o_vhdl = 5'b11011;
            o_verilog = 5'b00100;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
