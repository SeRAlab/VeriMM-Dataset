`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] theInput;
    wire [27:0] resultOfShiftLeft2Add2bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .theInput(theInput),
        .resultOfShiftLeft2Add2bits(resultOfShiftLeft2Add2bits)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros input", test_num);
            theInput = 26'h0000000;
            #1;

            check_outputs(28'h0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones input (26 bits)", test_num);
            theInput = 26'h3FFFFFF;


            #1;



            check_outputs(28'hFFFFFFFC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single LSB bit", test_num);
            theInput = 26'h0000001;
            #1;

            check_outputs(28'h0000004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single MSB bit", test_num);
            theInput = 26'h2000000;

            #1;


            check_outputs(28'h8000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern 0x1555555", test_num);
            theInput = 26'h1555555;
            #1;

            check_outputs(28'h5555554);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern 0x2AAAAAA", test_num);
            theInput = 26'h2AAAAAA;
            #1;

            check_outputs(28'hAAAAAA8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle range value", test_num);
            theInput = 26'h0ABCDEF;
            #1;

            check_outputs(28'h2AF37BC);
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
        input [27:0] expected_resultOfShiftLeft2Add2bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resultOfShiftLeft2Add2bits === (expected_resultOfShiftLeft2Add2bits ^ resultOfShiftLeft2Add2bits ^ expected_resultOfShiftLeft2Add2bits)) begin
                $display("PASS");
                $display("  Outputs: resultOfShiftLeft2Add2bits=%h",
                         resultOfShiftLeft2Add2bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resultOfShiftLeft2Add2bits=%h",
                         expected_resultOfShiftLeft2Add2bits);
                $display("  Got:      resultOfShiftLeft2Add2bits=%h",
                         resultOfShiftLeft2Add2bits);
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
