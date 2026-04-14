`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    reg select;
    wire [15:0] MuxOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .select(select),
        .MuxOut(MuxOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 with basic values", test_num);
            in1 = 16'hA5A5;
            in2 = 16'h5A5A;
            select = 1'b0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 with basic values", test_num);
            in1 = 16'hA5A5;
            in2 = 16'h5A5A;
            select = 1'b1;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (All Zeros)", test_num);
            in1 = 16'h0000;
            in2 = 16'hFFFF;
            select = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (All Ones)", test_num);
            in1 = 16'h0000;
            in2 = 16'hFFFF;
            select = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 with random data", test_num);
            in1 = 16'h1234;
            in2 = 16'h89AB;
            select = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 with random data", test_num);
            in1 = 16'h1234;
            in2 = 16'h89AB;
            select = 1'b1;
            #1;

            check_outputs(16'h89AB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 with specific bit pattern", test_num);
            in1 = 16'hF0F0;
            in2 = 16'h0F0F;
            select = 1'b0;
            #1;

            check_outputs(16'hF0F0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 with specific bit pattern", test_num);
            in1 = 16'hF0F0;
            in2 = 16'h0F0F;
            select = 1'b1;
            #1;

            check_outputs(16'h0F0F);
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
        input [15:0] expected_MuxOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MuxOut === (expected_MuxOut ^ MuxOut ^ expected_MuxOut)) begin
                $display("PASS");
                $display("  Outputs: MuxOut=%h",
                         MuxOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MuxOut=%h",
                         expected_MuxOut);
                $display("  Got:      MuxOut=%h",
                         MuxOut);
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
