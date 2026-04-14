`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg INPUT__TREADY;
    reg [15:0] OUTPUT__TDATA;
    reg OUTPUT__TLAST;
    reg OUTPUT__TVALID;
    wire [15:0] INPUT__TDATA;
    wire INPUT__TLAST;
    wire INPUT__TVALID;
    wire OUTPUT__TREADY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INPUT__TREADY(INPUT__TREADY),
        .OUTPUT__TDATA(OUTPUT__TDATA),
        .OUTPUT__TLAST(OUTPUT__TLAST),
        .OUTPUT__TVALID(OUTPUT__TVALID),
        .INPUT__TDATA(INPUT__TDATA),
        .INPUT__TLAST(INPUT__TLAST),
        .INPUT__TVALID(INPUT__TVALID),
        .OUTPUT__TREADY(OUTPUT__TREADY)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State (All signals 0)", test_num);
            INPUT__TREADY = 1'b0;
            OUTPUT__TDATA = 16'h0000;
            OUTPUT__TLAST = 1'b0;
            OUTPUT__TVALID = 1'b0;

            #1;


            check_outputs(16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Active Transfer (Valid=1, Ready=1)", test_num);
            INPUT__TREADY = 1'b1;
            OUTPUT__TDATA = 16'hA5A5;
            OUTPUT__TLAST = 1'b0;
            OUTPUT__TVALID = 1'b1;

            #1;


            check_outputs(16'hA5A5, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Last Word Transfer (Last=1)", test_num);
            INPUT__TREADY = 1'b1;
            OUTPUT__TDATA = 16'h5A5A;
            OUTPUT__TLAST = 1'b1;
            OUTPUT__TVALID = 1'b1;

            #1;


            check_outputs(16'h5A5A, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Backpressure (Valid=1, Ready=0)", test_num);
            INPUT__TREADY = 1'b0;
            OUTPUT__TDATA = 16'hDEAD;
            OUTPUT__TLAST = 1'b0;
            OUTPUT__TVALID = 1'b1;

            #1;


            check_outputs(16'hDEAD, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Downstream Ready, No Data (Valid=0, Ready=1)", test_num);
            INPUT__TREADY = 1'b1;
            OUTPUT__TDATA = 16'hBEEF;
            OUTPUT__TLAST = 1'b0;
            OUTPUT__TVALID = 1'b0;

            #1;


            check_outputs(16'hBEEF, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (All signals 1)", test_num);
            INPUT__TREADY = 1'b1;
            OUTPUT__TDATA = 16'hFFFF;
            OUTPUT__TLAST = 1'b1;
            OUTPUT__TVALID = 1'b1;

            #1;


            check_outputs(16'hFFFF, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data Integrity Check", test_num);
            INPUT__TREADY = 1'b1;
            OUTPUT__TDATA = 16'h1234;
            OUTPUT__TLAST = 1'b0;
            OUTPUT__TVALID = 1'b1;

            #1;


            check_outputs(16'h1234, 1'b0, 1'b1, 1'b1);
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
        input [15:0] expected_INPUT__TDATA;
        input expected_INPUT__TLAST;
        input expected_INPUT__TVALID;
        input expected_OUTPUT__TREADY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_INPUT__TDATA === (expected_INPUT__TDATA ^ INPUT__TDATA ^ expected_INPUT__TDATA) &&
                expected_INPUT__TLAST === (expected_INPUT__TLAST ^ INPUT__TLAST ^ expected_INPUT__TLAST) &&
                expected_INPUT__TVALID === (expected_INPUT__TVALID ^ INPUT__TVALID ^ expected_INPUT__TVALID) &&
                expected_OUTPUT__TREADY === (expected_OUTPUT__TREADY ^ OUTPUT__TREADY ^ expected_OUTPUT__TREADY)) begin
                $display("PASS");
                $display("  Outputs: INPUT__TDATA=%h, INPUT__TLAST=%b, INPUT__TVALID=%b, OUTPUT__TREADY=%b",
                         INPUT__TDATA, INPUT__TLAST, INPUT__TVALID, OUTPUT__TREADY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INPUT__TDATA=%h, INPUT__TLAST=%b, INPUT__TVALID=%b, OUTPUT__TREADY=%b",
                         expected_INPUT__TDATA, expected_INPUT__TLAST, expected_INPUT__TVALID, expected_OUTPUT__TREADY);
                $display("  Got:      INPUT__TDATA=%h, INPUT__TLAST=%b, INPUT__TVALID=%b, OUTPUT__TREADY=%b",
                         INPUT__TDATA, INPUT__TLAST, INPUT__TVALID, OUTPUT__TREADY);
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
