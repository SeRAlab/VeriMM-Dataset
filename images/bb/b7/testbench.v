`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg EN;
    reg [3:0] data_in;
    reg [1:0] shift;
    wire [7:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .EN(EN),
        .data_in(data_in),
        .shift(shift),
        .final_output(final_output)
    );
    task testcase001;

        begin
            test_num = 1;
            EN = 0; A = 2'b00; B = 2'b00; data_in = 4'b1010; shift = 2'b01;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            EN = 1; A = 2'b00; B = 2'b00; data_in = 4'b0000; shift = 2'b00;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            EN = 1; A = 2'b00; B = 2'b00; data_in = 4'b0001; shift = 2'b00;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            EN = 1; A = 2'b00; B = 2'b10; data_in = 4'b0000; shift = 2'b00;

            #1;


            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            EN = 1; A = 2'b00; B = 2'b10; data_in = 4'b0001; shift = 2'b10;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            EN = 1; A = 2'b01; B = 2'b00; data_in = 4'b0000; shift = 2'b00;

            #1;


            check_outputs(8'hEF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            EN = 1; A = 2'b01; B = 2'b00; data_in = 4'b0001; shift = 2'b00;

            #1;


            check_outputs(8'hEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            EN = 1; A = 2'b01; B = 2'b11; data_in = 4'b0000; shift = 2'b00;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            EN = 1; A = 2'b10; B = 2'b00; data_in = 4'b0000; shift = 2'b00;

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_final_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h",
                         expected_final_output);
                $display("  Got:      final_output=%h",
                         final_output);
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
