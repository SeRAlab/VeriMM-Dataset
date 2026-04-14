`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] adler_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .adler_out(adler_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero input (00, 00)", test_num);
        data_in = 16'h0000;




        #1;





        check_outputs(16'h0201);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input (61, 62) - ASCII 'ba'", test_num);
        data_in = 16'h6162;




        #1;





        check_outputs(16'h2CC4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input (12, 34)", test_num);
        data_in = 16'h1234;




        #1;





        check_outputs(16'h7C47);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values (FF, FF)", test_num);
        data_in = 16'hFFFF;




        #1;





        check_outputs(16'h0E09);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed small values (01, 01)", test_num);
        data_in = 16'h0101;




        #1;





        check_outputs(16'h0503);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed values (FF, 00)", test_num);
        data_in = 16'hFF00;




        #1;





        check_outputs(16'h0605);
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
        input [15:0] expected_adler_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adler_out === (expected_adler_out ^ adler_out ^ expected_adler_out)) begin
                $display("PASS");
                $display("  Outputs: adler_out=%h",
                         adler_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adler_out=%h",
                         expected_adler_out);
                $display("  Got:      adler_out=%h",
                         adler_out);
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
