`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg addnsub;
    reg [143:0] datain;
    reg [3:0] operation;
    wire [143:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addnsub(addnsub),
        .datain(datain),
        .operation(operation),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Non-dynamic Bypass Mode", test_num);
            operation = 4'd0;
            addnsub = 1'b0;
            datain = 144'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111_2222;


            #1;



            check_outputs(144'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111_2222);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Accumulator Reordering Mode", test_num);
            operation = 4'd1;
            addnsub = 1'b0;
            datain = 144'h1111_2222_3333_4444_5555_6666_7777_8888_9999;




            #1;
            #1;

            check_outputs(dataout);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Specific Sections Mode", test_num);
            operation = 4'd2;
            addnsub = 1'b0;
            datain = {72'hFFFF_FFFF_FFFF_FFFF_FF, 72'h0000_0000_0000_0000_00};

            #1;
            #1;

            check_outputs(dataout);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 36-bit Multiplier Mode (Addition)", test_num);
            operation = 4'd3;
            addnsub = 1'b1;
            datain = 144'h5555_AAAA_5555_AAAA_5555_AAAA_5555_AAAA_5555;

            #1;
            #1;

            check_outputs(dataout);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 36-bit Multiplier Mode (Subtraction)", test_num);
            operation = 4'd3;
            addnsub = 1'b0;
            datain = 144'h5555_AAAA_5555_AAAA_5555_AAAA_5555_AAAA_5555;

            #1;
            #1;

            check_outputs(dataout);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Bits High Pattern", test_num);
            operation = 4'd4;
            addnsub = 1'b1;
            datain = {144{1'b1}};

            #1;
            #1;

            check_outputs(dataout);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Bits Low Pattern", test_num);
            operation = 4'd5;
            addnsub = 1'b0;
            datain = 144'd0;

            #1;

            #1;


            check_outputs(144'd0);
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
        input [143:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
