`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] mux_in1;
    reg [15:0] mux_in2;
    reg mux_sel;
    wire [15:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mux_in1(mux_in1),
        .mux_in2(mux_in2),
        .mux_sel(mux_sel),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting mux_in1 with standard pattern", test_num);
            mux_sel = 1'b0;
            mux_in1 = 16'hAAAA;
            mux_in2 = 16'h5555;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting mux_in2 with standard pattern", test_num);
            mux_sel = 1'b1;
            mux_in1 = 16'hAAAA;
            mux_in2 = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select mux_in1 with all zeros", test_num);
            mux_sel = 1'b0;
            mux_in1 = 16'h0000;
            mux_in2 = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select mux_in2 with all ones", test_num);
            mux_sel = 1'b1;
            mux_in1 = 16'h0000;
            mux_in2 = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data input change while mux_sel is low", test_num);
            mux_sel = 1'b0;
            mux_in1 = 16'h1234;
            mux_in2 = 16'hABCD;
            #5;
            mux_in1 = 16'h5678;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data input change while mux_sel is high", test_num);
            mux_sel = 1'b1;
            mux_in1 = 16'h1234;
            mux_in2 = 16'hABCD;
            #5;
            mux_in2 = 16'hFEDC;
            #1;

            check_outputs(16'hFEDC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selection switch with identical inputs", test_num);
            mux_in1 = 16'h8001;
            mux_in2 = 16'h8001;
            mux_sel = 1'b0;
            #5;
            mux_sel = 1'b1;
            #1;

            check_outputs(16'h8001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit pattern on input 1", test_num);
            mux_sel = 1'b0;
            mux_in1 = 16'h0001;
            mux_in2 = 16'h0000;
            #5;
            mux_in1 = 16'h0002;
            #5;
            mux_in1 = 16'h8000;
            #1;

            check_outputs(16'h8000);
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
        input [15:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
