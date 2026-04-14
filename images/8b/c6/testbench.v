`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dataIn;
    wire [7:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataIn(dataIn),
        .dataOut(dataOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: dataIn = 8'h1D", test_num);
            dataIn = 8'h1D;
            #1;

            check_outputs(8'd87);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: dataIn = 8'h1B", test_num);
            dataIn = 8'h1B;
            #1;

            check_outputs(8'd83);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: dataIn = 8'h1C", test_num);
            dataIn = 8'h1C;
            #1;

            check_outputs(8'd65);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: dataIn = 8'h23", test_num);
            dataIn = 8'h23;
            #1;

            check_outputs(8'd68);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: dataIn = 8'h00 (Default)", test_num);
            dataIn = 8'h00;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: dataIn = 8'hFF (Default)", test_num);
            dataIn = 8'hFF;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: dataIn = 8'h1A (Non-mapped)", test_num);
            dataIn = 8'h1A;
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_dataOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h",
                         expected_dataOut);
                $display("  Got:      dataOut=%h",
                         dataOut);
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
