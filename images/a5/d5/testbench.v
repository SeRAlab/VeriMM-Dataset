`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Logical Shift (1011 << 1)", test_num);
        data_in = 4'b1011;
        control = 2'b00;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Right Logical Shift (1011 >> 1)", test_num);
        data_in = 4'b1011;
        control = 2'b01;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Circular Left Shift (1011 rotL)", test_num);
        data_in = 4'b1011;
        control = 2'b10;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Circular Right Shift (1011 rotR)", test_num);
        data_in = 4'b1011;
        control = 2'b11;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Left Logical Shift (1111 -> 1110)", test_num);
        data_in = 4'b1111;
        control = 2'b00;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Right Logical Shift (1111 -> 0111)", test_num);
        data_in = 4'b1111;
        control = 2'b01;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Circular Left Shift (0001 -> 0010)", test_num);
        data_in = 4'b0001;
        control = 2'b10;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Circular Right Shift (1000 -> 0100)", test_num);
        data_in = 4'b1000;
        control = 2'b11;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero input shift", test_num);
        data_in = 4'b0000;
        control = 2'b10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Circular Left Shift (1000 -> 0001)", test_num);
        data_in = 4'b1000;
        control = 2'b10;
        #1;

        check_outputs(4'b0001);
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
