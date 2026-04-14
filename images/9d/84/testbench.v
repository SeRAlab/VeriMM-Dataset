`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [7:0] data_in;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .data_in(data_in),
        .parity(parity)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control Low, Data 0", test_num);
            control = 1'b0;
            data_in = 8'b00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control Low, Data All Ones", test_num);
            control = 1'b0;
            data_in = 8'b11111111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 0 (Even Parity -> 0)", test_num);
            control = 1'b1;
            data_in = 8'b00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 1 (Odd Parity -> 1)", test_num);
            control = 1'b1;
            data_in = 8'b00000001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 3 (Even Parity -> 0)", test_num);
            control = 1'b1;
            data_in = 8'b00000011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 0xAA (Even Parity -> 0)", test_num);
            control = 1'b1;
            data_in = 8'b10101010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 0x55 (Even Parity -> 0)", test_num);
            control = 1'b1;
            data_in = 8'b01010101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 0xFF (Even Parity -> 0)", test_num);
            control = 1'b1;
            data_in = 8'b11111111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 0x7F (Odd Parity -> 1)", test_num);
            control = 1'b1;
            data_in = 8'b01111111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control High, Data 0x80 (Odd Parity -> 1)", test_num);
            control = 1'b1;
            data_in = 8'b10000000;
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
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
