`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire [7:0] addOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .addOut(addOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            in1 = 8'h00;
            in2 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Addition (FF + 0)", test_num);
            in1 = 8'hFF;
            in2 = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (05 + 0A)", test_num);
            in1 = 8'h05;
            in2 = 8'h0A;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Range No Overflow (7F + 80)", test_num);
            in1 = 8'h7F;
            in2 = 8'h80;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Case (FF + 01)", test_num);
            in1 = 8'hFF;
            in2 = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit Pattern Addition (AA + 55)", test_num);
            in1 = 8'hAA;
            in2 = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Value Overflow (C8 + 64)", test_num);

            in1 = 8'd200;
            in2 = 8'd100;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Overflow (FF + FF)", test_num);

            in1 = 8'hFF;
            in2 = 8'hFF;
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_addOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addOut === (expected_addOut ^ addOut ^ expected_addOut)) begin
                $display("PASS");
                $display("  Outputs: addOut=%h",
                         addOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addOut=%h",
                         expected_addOut);
                $display("  Got:      addOut=%h",
                         addOut);
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
