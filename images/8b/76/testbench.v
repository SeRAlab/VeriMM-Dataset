`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 8'b00000000;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 8'b00000001;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 8'b00010000;
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 8'b10000000;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 8'b00000011;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 8'b00000110;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 8'b11000000;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 8'b10101010;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 8'b11111111;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 8'b01010101;
            #1;

            check_outputs(8'b00000001);
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
        input [7:0] expected_data_out;
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
