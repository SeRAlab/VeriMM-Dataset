`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Top_Pad_input;
    reg VREF;
    reg cbit_7;
    wire input_;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Top_Pad_input(Top_Pad_input),
        .VREF(VREF),
        .cbit_7(cbit_7),
        .input_(input_)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select VREF (cbit_7=0), VREF=0", test_num);
            cbit_7 = 1'b0;
            VREF = 1'b0;
            Top_Pad_input = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select VREF (cbit_7=0), VREF=1", test_num);
            cbit_7 = 1'b0;
            VREF = 1'b1;
            Top_Pad_input = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Top_Pad (cbit_7=1), Top_Pad_input=0", test_num);
            cbit_7 = 1'b1;
            Top_Pad_input = 1'b0;
            VREF = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select Top_Pad (cbit_7=1), Top_Pad_input=1", test_num);
            cbit_7 = 1'b1;
            Top_Pad_input = 1'b1;
            VREF = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs High, Select VREF", test_num);
            cbit_7 = 1'b0;
            VREF = 1'b1;
            Top_Pad_input = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs Low, Select Top_Pad", test_num);
            cbit_7 = 1'b1;
            VREF = 1'b0;
            Top_Pad_input = 1'b0;
            #1;

            check_outputs(1'b0);
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
        input expected_input_;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_input_ === (expected_input_ ^ input_ ^ expected_input_)) begin
                $display("PASS");
                $display("  Outputs: input_=%b",
                         input_);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: input_=%b",
                         expected_input_);
                $display("  Got:      input_=%b",
                         input_);
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
