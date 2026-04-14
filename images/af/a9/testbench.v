`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    wire [3:0] corrected_data;
    wire [6:0] encoded_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .corrected_data(corrected_data),
        .encoded_data(encoded_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            data_in = 4'b0000;

            #1;


            check_outputs(4'b0000, 7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            data_in = 4'b1111;

            #1;


            check_outputs(4'b1111, 7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit D0", test_num);
            data_in = 4'b0001;

            #1;


            check_outputs(4'b0001, 7'h07);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit D1", test_num);
            data_in = 4'b0010;

            #1;


            check_outputs(4'b0010, 7'h19);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit D2", test_num);
            data_in = 4'b0100;

            #1;


            check_outputs(4'b0100, 7'h2A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit D3", test_num);
            data_in = 4'b1000;

            #1;


            check_outputs(4'b1000, 7'h4B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 1010", test_num);
            data_in = 4'b1010;

            #1;


            check_outputs(4'b1010, 7'h52);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 0101", test_num);
            data_in = 4'b0101;

            #1;


            check_outputs(4'b0101, 7'h2D);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 0011", test_num);
            data_in = 4'b0011;

            #1;


            check_outputs(4'b0011, 7'h1E);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1100", test_num);
            data_in = 4'b1100;

            #1;


            check_outputs(4'b1100, 7'h61);
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
        input [3:0] expected_corrected_data;
        input [6:0] expected_encoded_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_corrected_data === (expected_corrected_data ^ corrected_data ^ expected_corrected_data) &&
                expected_encoded_data === (expected_encoded_data ^ encoded_data ^ expected_encoded_data)) begin
                $display("PASS");
                $display("  Outputs: corrected_data=%h, encoded_data=%h",
                         corrected_data, encoded_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected_data=%h, encoded_data=%h",
                         expected_corrected_data, expected_encoded_data);
                $display("  Got:      corrected_data=%h, encoded_data=%h",
                         corrected_data, encoded_data);
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
