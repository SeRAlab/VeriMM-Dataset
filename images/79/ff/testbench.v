`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] amount;
    reg ivalue;
    wire ovalue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .ivalue(ivalue),
        .ovalue(ovalue)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            ivalue = 4'b1011;
            amount = 2'b00;
            #10;
            $display("Test %0d: Shift 4'b1011 by 0 positions", test_num);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            ivalue = 4'b1011;
            amount = 2'b01;
            #10;
            $display("Test %0d: Shift 4'b1011 by 1 position", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            ivalue = 4'b1011;
            amount = 2'b10;
            #10;
            $display("Test %0d: Shift 4'b1011 by 2 positions", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            ivalue = 4'b1011;
            amount = 2'b11;
            #10;
            $display("Test %0d: Shift 4'b1011 by 3 positions", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            ivalue = 4'b1111;
            amount = 2'b10;
            #10;
            $display("Test %0d: Shift 4'b1111 by 2 positions", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            ivalue = 4'b1000;
            amount = 2'b11;
            #10;
            $display("Test %0d: Shift 4'b1000 by 3 positions", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            ivalue = 4'b0100;
            amount = 2'b11;
            #10;
            $display("Test %0d: Shift 4'b0100 by 3 positions (should be 0)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            ivalue = 4'b0000;
            amount = 2'b01;
            #10;
            $display("Test %0d: Shift 4'b0000 by 1 position", test_num);
            #1;

            check_outputs(4'b0000);
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
        input expected_ovalue;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ovalue === (expected_ovalue ^ ovalue ^ expected_ovalue)) begin
                $display("PASS");
                $display("  Outputs: ovalue=%b",
                         ovalue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ovalue=%b",
                         expected_ovalue);
                $display("  Got:      ovalue=%b",
                         ovalue);
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
