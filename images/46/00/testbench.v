`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg is_jg;
    reg is_jl;
    reg is_jnz;
    reg is_jump;
    reg is_jz;
    reg is_sign;
    reg is_zero;
    wire should_jump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .is_jg(is_jg),
        .is_jl(is_jl),
        .is_jnz(is_jnz),
        .is_jump(is_jump),
        .is_jz(is_jz),
        .is_sign(is_sign),
        .is_zero(is_zero),
        .should_jump(should_jump)
    );
    task testcase001;

        begin
            test_num = 1;
            is_jz = 0; is_jnz = 0; is_jl = 0; is_jg = 0; is_jump = 1;
            is_zero = 0; is_sign = 0;
            $display("Testcase %0d: Unconditional jump (is_jump=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            is_jz = 1; is_jnz = 0; is_jl = 0; is_jg = 0; is_jump = 0;
            is_zero = 1; is_sign = 0;
            $display("Testcase %0d: JZ condition met (is_jz=1, is_zero=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            is_jz = 1; is_jnz = 0; is_jl = 0; is_jg = 0; is_jump = 0;
            is_zero = 0; is_sign = 0;
            $display("Testcase %0d: JZ condition not met (is_jz=1, is_zero=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            is_jz = 0; is_jnz = 1; is_jl = 0; is_jg = 0; is_jump = 0;
            is_zero = 0; is_sign = 0;
            $display("Testcase %0d: JNZ condition met (is_jnz=1, is_zero=0)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            is_jz = 0; is_jnz = 1; is_jl = 0; is_jg = 0; is_jump = 0;
            is_zero = 1; is_sign = 0;
            $display("Testcase %0d: JNZ condition not met (is_jnz=1, is_zero=1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            is_jz = 0; is_jnz = 0; is_jl = 1; is_jg = 0; is_jump = 0;
            is_zero = 0; is_sign = 1;
            $display("Testcase %0d: JL condition met (is_jl=1, is_sign=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            is_jz = 0; is_jnz = 0; is_jl = 1; is_jg = 0; is_jump = 0;
            is_zero = 0; is_sign = 0;
            $display("Testcase %0d: JL condition not met (is_jl=1, is_sign=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            is_jz = 0; is_jnz = 0; is_jl = 0; is_jg = 1; is_jump = 0;
            is_zero = 0; is_sign = 0;
            $display("Testcase %0d: JG condition met (is_jg=1, is_sign=0, is_zero=0)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            is_jz = 0; is_jnz = 0; is_jl = 0; is_jg = 1; is_jump = 0;
            is_zero = 1; is_sign = 0;
            $display("Testcase %0d: JG condition not met (is_jg=1, is_zero=1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            is_jz = 0; is_jnz = 0; is_jl = 0; is_jg = 1; is_jump = 0;
            is_zero = 0; is_sign = 1;
            $display("Testcase %0d: JG condition not met (is_jg=1, is_sign=1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            is_jz = 0; is_jnz = 0; is_jl = 0; is_jg = 0; is_jump = 0;
            is_zero = 1; is_sign = 1;
            $display("Testcase %0d: No jump signals active", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            is_jz = 1; is_jnz = 0; is_jl = 1; is_jg = 0; is_jump = 0;
            is_zero = 0; is_sign = 1;
            $display("Testcase %0d: JL met while JZ is active but not met", test_num);
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
        input expected_should_jump;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_should_jump === (expected_should_jump ^ should_jump ^ expected_should_jump)) begin
                $display("PASS");
                $display("  Outputs: should_jump=%b",
                         should_jump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: should_jump=%b",
                         expected_should_jump);
                $display("  Got:      should_jump=%b",
                         should_jump);
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
