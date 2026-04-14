`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [15:0] data_out;

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
            data_in = 32'h0000_AAAA;
            $display("Test %0d: MSB=00, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 32'h4000_1234;
            $display("Test %0d: MSB=01, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 32'h8765_4321;
            $display("Test %0d: MSB=10, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'h8765);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 32'hC0F0_FFFF;
            $display("Test %0d: MSB=11, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'h3F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 32'h0000_0000;
            $display("Test %0d: MSB=00, All Zeros, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 32'hFFFF_FFFF;
            $display("Test %0d: MSB=11, All Ones, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 32'h7FFF_ABCD;
            $display("Test %0d: MSB=01 edge, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 32'hBFFF_1234;
            $display("Test %0d: MSB=10 edge, data_in=%h", test_num, data_in);
            #1;

            check_outputs(16'hBFFF);
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
