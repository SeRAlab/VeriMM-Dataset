`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] in0;
    reg [63:0] in1;
    reg sel;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in0", test_num);
        in0 = 64'h0123456789ABCDEF;
        in1 = 64'hFEDCBA9876543210;
        sel = 1'b0;
        #5;
        #1;

        check_outputs(64'h0123456789ABCDEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select in1", test_num);
        in0 = 64'h0123456789ABCDEF;
        in1 = 64'hFEDCBA9876543210;
        sel = 1'b1;
        #5;
        #1;

        check_outputs(64'hFEDCBA9876543210);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros (in0) vs All ones (in1), sel=0", test_num);
        in0 = 64'h0000000000000000;
        in1 = 64'hFFFFFFFFFFFFFFFF;
        sel = 1'b0;
        #5;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros (in0) vs All ones (in1), sel=1", test_num);
        in0 = 64'h0000000000000000;
        in1 = 64'hFFFFFFFFFFFFFFFF;
        sel = 1'b1;
        #5;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard pattern, sel=0", test_num);
        in0 = 64'hAAAAAAAAAAAAAAAA;
        in1 = 64'h5555555555555555;
        sel = 1'b0;
        #5;
        #1;

        check_outputs(64'hAAAAAAAAAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checkerboard pattern, sel=1", test_num);
        in0 = 64'hAAAAAAAAAAAAAAAA;
        in1 = 64'h5555555555555555;
        sel = 1'b1;
        #5;
        #1;

        check_outputs(64'h5555555555555555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Walking bit pattern, sel=0", test_num);
        in0 = 64'h8000000000000001;
        in1 = 64'h0000000000000000;
        sel = 1'b0;
        #5;
        #1;

        check_outputs(64'h8000000000000001);
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
