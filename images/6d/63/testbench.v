`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [3:0] shift_amount;
    wire [15:0] data_out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Shift amount 0", test_num);
            data_in = 16'hABCD;
            shift_amount = 4'd0;
            #1;

            check_outputs(16'hABCD, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift amount 1", test_num);
            data_in = 16'h0001;
            shift_amount = 4'd1;
            #1;

            check_outputs(16'h0002, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift amount 4", test_num);
            data_in = 16'hF00F;
            shift_amount = 4'd4;
            #1;

            check_outputs(16'h00F0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift amount 8", test_num);
            data_in = 16'h00FF;
            shift_amount = 4'd8;
            #1;

            check_outputs(16'hFF00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift amount 12", test_num);
            data_in = 16'h000F;
            shift_amount = 4'd12;
            #1;

            check_outputs(16'hF000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Shift amount 15", test_num);
            data_in = 16'h0001;
            shift_amount = 4'd15;
            #1;

            check_outputs(16'h8000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Shift left 15 with overflowed content", test_num);
            data_in = 16'hFFFF;
            shift_amount = 4'd15;
            #1;

            check_outputs(16'h8000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Complex pattern shift 7", test_num);
            data_in = 16'h5555;
            shift_amount = 4'd7;


            #1;



            check_outputs(16'hAA80, 1'b0);
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
        input [15:0] expected_data_out;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, overflow=%b",
                         data_out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, overflow=%b",
                         expected_data_out, expected_overflow);
                $display("  Got:      data_out=%h, overflow=%b",
                         data_out, overflow);
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
