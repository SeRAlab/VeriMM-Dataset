`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] cond;
    reg [15:0] cx;
    reg is_cx;
    reg [4:0] logic_flags;
    wire jmp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cond(cond),
        .cx(cx),
        .is_cx(is_cx),
        .logic_flags(logic_flags),
        .jmp(jmp)
    );
    task testcase001;

        begin
            test_num = 1;
            is_cx = 1; cx = 16'h0000; cond = 4'h0; logic_flags = 5'b00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            is_cx = 1; cx = 16'h0001; cond = 4'h0; logic_flags = 5'b11111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            is_cx = 0; cond = 4'h4; logic_flags = 5'b00010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            is_cx = 0; cond = 4'h4; logic_flags = 5'b11101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            is_cx = 0; cond = 4'h5; logic_flags = 5'b00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            is_cx = 0; cond = 4'h2; logic_flags = 5'b00001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            is_cx = 0; cond = 4'h7; logic_flags = 5'b00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            is_cx = 0; cond = 4'h8; logic_flags = 5'b00100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            is_cx = 0; cond = 4'h0; logic_flags = 5'b01000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            is_cx = 0; cond = 4'hc; logic_flags = 5'b00100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            is_cx = 0; cond = 4'hd; logic_flags = 5'b01100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            is_cx = 0; cond = 4'h6; logic_flags = 5'b00010;
            #1;

            check_outputs(1'b1);
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
        testcase011();
        testcase012();
        
        
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
        input expected_jmp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jmp === (expected_jmp ^ jmp ^ expected_jmp)) begin
                $display("PASS");
                $display("  Outputs: jmp=%b",
                         jmp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jmp=%b",
                         expected_jmp);
                $display("  Got:      jmp=%b",
                         jmp);
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
