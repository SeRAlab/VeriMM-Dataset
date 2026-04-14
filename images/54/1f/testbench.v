`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] subOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .subOut(subOut)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 8'd10;
        in2 = 8'd5;
        $display("Testcase %0d: in1=10, in2=5", test_num);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 8'd128;
        in2 = 8'd128;
        $display("Testcase %0d: in1=128, in2=128", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 8'd0;
        in2 = 8'd1;
        $display("Testcase %0d: in1=0, in2=1", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 8'hFF;
        in2 = 8'h00;
        $display("Testcase %0d: in1=255, in2=0", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 8'd50;
        in2 = 8'd100;
        $display("Testcase %0d: in1=50, in2=100", test_num);
        #1;

        check_outputs(8'd206);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 8'hFF;
        in2 = 8'h01;
        $display("Testcase %0d: in1=255, in2=1", test_num);
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 8'h01;
        in2 = 8'hFF;
        $display("Testcase %0d: in1=1, in2=255", test_num);
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 8'hAA;
        in2 = 8'h55;
        $display("Testcase %0d: in1=0xAA, in2=0x55", test_num);
        #1;

        check_outputs(8'h55);
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
        input [7:0] expected_subOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_subOut === (expected_subOut ^ subOut ^ expected_subOut)) begin
                $display("PASS");
                $display("  Outputs: subOut=%h",
                         subOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: subOut=%h",
                         expected_subOut);
                $display("  Got:      subOut=%h",
                         subOut);
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
