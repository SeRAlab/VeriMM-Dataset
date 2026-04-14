`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] shift;
    wire [2:0] comparison_result;
    wire [3:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .shift(shift),
        .comparison_result(comparison_result),
        .final_output(final_output)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'b0110;
        b = 4'b0010;
        shift = 2'b00;



        #1;




        check_outputs(3'b100, 4'b0110);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'b0011;
        b = 4'b0111;
        shift = 2'b00;



        #1;




        check_outputs(3'b010, 4'b0111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'b1010;
        b = 4'b1010;
        shift = 2'b00;



        #1;




        check_outputs(3'b001, 4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'b0010;
        b = 4'b0100;
        shift = 2'b01;



        #1;




        check_outputs(3'b001, 4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'b0101;
        b = 4'b0010;
        shift = 2'b01;



        #1;




        check_outputs(3'b100, 4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'b0001;
        b = 4'b1000;
        shift = 2'b10;



        #1;




        check_outputs(3'b010, 4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'b1001;
        b = 4'b0001;
        shift = 2'b11;



        #1;




        check_outputs(3'b100, 4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'b1111;
        b = 4'b1111;
        shift = 2'b00;



        #1;




        check_outputs(3'b001, 4'b1111);
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
        input [2:0] expected_comparison_result;
        input [3:0] expected_final_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comparison_result === (expected_comparison_result ^ comparison_result ^ expected_comparison_result) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: comparison_result=%h, final_output=%h",
                         comparison_result, final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comparison_result=%h, final_output=%h",
                         expected_comparison_result, expected_final_output);
                $display("  Got:      comparison_result=%h, final_output=%h",
                         comparison_result, final_output);
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
