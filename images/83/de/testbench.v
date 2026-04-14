`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [16:0] data_out_with_parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .data_out_with_parity(data_out_with_parity)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            data_in = 16'h0000;

            #1;


            check_outputs(17'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            data_in = 16'hFFFF;

            #1;


            check_outputs(17'h0FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit (LSB)", test_num);
            data_in = 16'h0001;

            #1;


            check_outputs(17'h10001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two Bits Set", test_num);
            data_in = 16'h0003;

            #1;


            check_outputs(17'h00003);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern AAAA", test_num);
            data_in = 16'hAAAA;

            #1;


            check_outputs(17'h0AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 5555", test_num);
            data_in = 16'h5555;

            #1;


            check_outputs(17'h05555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Odd Bit Count (1234)", test_num);
            data_in = 16'h1234;


            #1;



            check_outputs(17'h11234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Set", test_num);
            data_in = 16'h8000;

            #1;


            check_outputs(17'h18000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 Bits Set", test_num);
            data_in = 16'h7FFF;

            #1;


            check_outputs(17'h17FFF);
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
        input [16:0] expected_data_out_with_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out_with_parity === (expected_data_out_with_parity ^ data_out_with_parity ^ expected_data_out_with_parity)) begin
                $display("PASS");
                $display("  Outputs: data_out_with_parity=%h",
                         data_out_with_parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_with_parity=%h",
                         expected_data_out_with_parity);
                $display("  Got:      data_out_with_parity=%h",
                         data_out_with_parity);
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
