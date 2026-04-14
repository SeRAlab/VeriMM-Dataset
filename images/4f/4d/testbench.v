`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bp;
    reg ci;
    reg control;
    reg cprdt;
    reg gin;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bp(bp),
        .ci(ci),
        .control(control),
        .cprdt(cprdt),
        .gin(gin),
        .cout(cout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs zero", test_num);
            bp = 0; ci = 0; control = 0; cprdt = 0; gin = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Standard Carry Generate (gin=1)", test_num);
            bp = 0; ci = 0; control = 0; cprdt = 0; gin = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Standard Carry Propagate (cprdt=1, ci=1)", test_num);
            bp = 0; ci = 1; control = 0; cprdt = 1; gin = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Propagate without carry-in", test_num);
            bp = 0; ci = 0; control = 0; cprdt = 1; gin = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Carry-in without propagate", test_num);
            bp = 0; ci = 1; control = 0; cprdt = 0; gin = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Control feature active (control=1, bp=1)", test_num);
            bp = 1; ci = 0; control = 1; cprdt = 0; gin = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Control active but borrow/bp is zero", test_num);
            bp = 0; ci = 0; control = 1; cprdt = 0; gin = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: bp is 1 but control is zero", test_num);
            bp = 1; ci = 0; control = 0; cprdt = 0; gin = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Gin and Control/BP both active", test_num);
            bp = 1; ci = 0; control = 1; cprdt = 0; gin = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: All signals high", test_num);
            bp = 1; ci = 1; control = 1; cprdt = 1; gin = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Multiple carry paths (Propagate and BP/Control)", test_num);
            bp = 1; ci = 1; control = 1; cprdt = 1; gin = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Gin high with control/bp low", test_num);
            bp = 1; ci = 0; control = 0; cprdt = 0; gin = 1;
            #1;

            check_outputs(1);
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
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b",
                         cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b",
                         expected_cout);
                $display("  Got:      cout=%b",
                         cout);
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
