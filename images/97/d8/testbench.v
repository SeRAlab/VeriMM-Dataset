`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_input;
    wire [7:0] binary_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_input(binary_input),
        .binary_output(binary_output)
    );
    task testcase001;

    begin
        test_num = 1;
        binary_input = 8'h00;
        $display("Test %0d: Input = %h (MSB 0)", test_num, binary_input);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        binary_input = 8'h05;
        $display("Test %0d: Input = %h (MSB 0)", test_num, binary_input);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        binary_input = 8'h7F;
        $display("Test %0d: Input = %h (MSB 0)", test_num, binary_input);
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        binary_input = 8'h80;
        $display("Test %0d: Input = %h (MSB 1)", test_num, binary_input);
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        binary_input = 8'h85;
        $display("Test %0d: Input = %h (MSB 1)", test_num, binary_input);
        #1;

        check_outputs(8'h84);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        binary_input = 8'hFF;
        $display("Test %0d: Input = %h (MSB 1)", test_num, binary_input);
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        binary_input = 8'h40;
        $display("Test %0d: Input = %h (MSB 0)", test_num, binary_input);
        #1;

        check_outputs(8'h41);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        binary_input = 8'hC0;
        $display("Test %0d: Input = %h (MSB 1)", test_num, binary_input);
        #1;

        check_outputs(8'hBF);
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
        input [7:0] expected_binary_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_output === (expected_binary_output ^ binary_output ^ expected_binary_output)) begin
                $display("PASS");
                $display("  Outputs: binary_output=%h",
                         binary_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_output=%h",
                         expected_binary_output);
                $display("  Got:      binary_output=%h",
                         binary_output);
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
