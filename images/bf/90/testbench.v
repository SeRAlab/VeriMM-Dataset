`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] i_data_in;
    reg i_data_in_en;
    wire [7:0] decoder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data_in(i_data_in),
        .i_data_in_en(i_data_in_en),
        .decoder_out(decoder_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd0;
            #10;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd1;
            #10;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd2;
            #10;
            #1;

            check_outputs(8'b00100000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd3;
            #10;
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b0;
            i_data_in = 3'd7;
            #10;
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd4;
            #10;
            #1;

            check_outputs(8'b00001000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd5;
            #10;
            #1;

            check_outputs(8'b00000100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd6;
            #10;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b1;
            i_data_in = 3'd7;
            #10;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            i_data_in_en = 1'b0;
            i_data_in = 3'd0;
            #10;
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
        input [7:0] expected_decoder_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoder_out === (expected_decoder_out ^ decoder_out ^ expected_decoder_out)) begin
                $display("PASS");
                $display("  Outputs: decoder_out=%h",
                         decoder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoder_out=%h",
                         expected_decoder_out);
                $display("  Got:      decoder_out=%h",
                         decoder_out);
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
