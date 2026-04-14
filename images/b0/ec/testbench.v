`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] codeword_in;
    reg [3:0] data_in;
    wire [6:0] codeword_out;
    wire [3:0] data_out;
    wire error_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .codeword_in(codeword_in),
        .data_in(data_in),
        .codeword_out(codeword_out),
        .data_out(data_out),
        .error_detected(error_detected)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b0000, No Error", test_num);
            data_in = 4'b0000;
            #1;
            codeword_in = codeword_out;
            #1;

            check_outputs(7'b0000000, 4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b1111, No Error", test_num);
            data_in = 4'b1111;
            #1;
            codeword_in = codeword_out;


            #1;



            check_outputs(7'b1111111, 4'b1111, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b1010, No Error", test_num);
            data_in = 4'b1010;
            #1;
            codeword_in = codeword_out;

            #1;


            check_outputs(7'b1010010, 4'b1010, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b0000, Error in P1", test_num);
            data_in = 4'b0000;
            #1;
            codeword_in = codeword_out ^ 7'b0000001;
            #1;

            check_outputs(7'b0000000, 4'b0000, 1'b1);
        end
        endtask

    task testcase005;

        reg [6:0] clean_codeword;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b1111, Error in D3", test_num);
            data_in = 4'b1111;
            #1;
            clean_codeword = codeword_out;
            codeword_in = clean_codeword ^ 7'b0000100;
            #1;

            check_outputs(clean_codeword, 4'b1111, 1'b1);
        end
        endtask

    task testcase006;

        reg [6:0] clean_codeword;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b1010, Error in D7", test_num);
            data_in = 4'b1010;
            #1;
            clean_codeword = codeword_out;
            codeword_in = clean_codeword ^ 7'b1000000;
            #1;

            check_outputs(clean_codeword, 4'b1010, 1'b1);
        end
        endtask

    task testcase007;

        reg [6:0] clean_codeword;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b0101, Error in P4", test_num);
            data_in = 4'b0101;
            #1;
            clean_codeword = codeword_out;
            codeword_in = clean_codeword ^ 7'b0001000;
            #1;

            check_outputs(clean_codeword, 4'b0101, 1'b1);
        end
        endtask

    task testcase008;

        reg [6:0] clean_codeword;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Data 4'b1100, Error in D6", test_num);
            data_in = 4'b1100;
            #1;
            clean_codeword = codeword_out;
            codeword_in = clean_codeword ^ 7'b0100000;
            #1;

            check_outputs(clean_codeword, 4'b1100, 1'b1);
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
        input [6:0] expected_codeword_out;
        input [3:0] expected_data_out;
        input expected_error_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword_out === (expected_codeword_out ^ codeword_out ^ expected_codeword_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_detected === (expected_error_detected ^ error_detected ^ expected_error_detected)) begin
                $display("PASS");
                $display("  Outputs: codeword_out=%h, data_out=%h, error_detected=%b",
                         codeword_out, data_out, error_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword_out=%h, data_out=%h, error_detected=%b",
                         expected_codeword_out, expected_data_out, expected_error_detected);
                $display("  Got:      codeword_out=%h, data_out=%h, error_detected=%b",
                         codeword_out, data_out, error_detected);
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
