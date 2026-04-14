`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] cbe_i;
    reg clk_i;
    reg parOE_i;
    reg [31:0] pcidatout_i;
    wire par_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cbe_i(cbe_i),
        .clk_i(clk_i),
        .parOE_i(parOE_i),
        .pcidatout_i(pcidatout_i),
        .par_o(par_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase%03d: All zeros, OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'h00000000;
        cbe_i = 4'h0;
        @(posedge clk_i);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase%03d: One data bit set, OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'h00000001;
        cbe_i = 4'h0;
        @(posedge clk_i);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase%03d: One CBE bit set, OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'h00000000;
        cbe_i = 4'h1;
        @(posedge clk_i);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase%03d: All data bits set (32 ones), OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'hFFFFFFFF;
        cbe_i = 4'h0;
        @(posedge clk_i);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase%03d: All CBE bits set (4 ones), OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'h00000000;
        cbe_i = 4'hF;
        @(posedge clk_i);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase%03d: Output disabled (OE=0)", test_num);
        parOE_i = 1'b0;
        pcidatout_i = 32'hFFFFFFFF;
        cbe_i = 4'hF;
        @(posedge clk_i);
        #1;

        check_outputs(1'bz);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase%03d: Pattern with 15 ones, OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'h12345678;
        cbe_i = 4'h9;
        @(posedge clk_i);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase%03d: Pattern with 18 ones, OE=1", test_num);
        parOE_i = 1'b1;
        pcidatout_i = 32'hAAAAAAAA;
        cbe_i = 4'h5;
        @(posedge clk_i);
        #1;

        check_outputs(1'b0);
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
        input expected_par_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_par_o === (expected_par_o ^ par_o ^ expected_par_o)) begin
                $display("PASS");
                $display("  Outputs: par_o=%b",
                         par_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: par_o=%b",
                         expected_par_o);
                $display("  Got:      par_o=%b",
                         par_o);
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
