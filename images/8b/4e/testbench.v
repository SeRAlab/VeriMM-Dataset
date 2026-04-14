`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] one_in;
    reg [1:0] signal;
    reg [31:0] three_in;
    reg [31:0] two_in;
    reg [31:0] zero_in;
    wire [31:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .one_in(one_in),
        .signal(signal),
        .three_in(three_in),
        .two_in(two_in),
        .zero_in(zero_in),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        zero_in  = 32'hDEADBEEF;
        one_in   = 32'h00000000;
        two_in   = 32'h00000000;
        three_in = 32'h00000000;
        signal   = 2'b00;
        $display("Test Case %0d: Selecting zero_in (signal=00)", test_num);
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        zero_in  = 32'h00000000;
        one_in   = 32'hCAFEBABE;
        two_in   = 32'h00000000;
        three_in = 32'h00000000;
        signal   = 2'b01;
        $display("Test Case %0d: Selecting one_in (signal=01)", test_num);
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        zero_in  = 32'h00000000;
        one_in   = 32'h00000000;
        two_in   = 32'h12345678;
        three_in = 32'h00000000;
        signal   = 2'b10;
        $display("Test Case %0d: Selecting two_in (signal=10)", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        zero_in  = 32'h00000000;
        one_in   = 32'h00000000;
        two_in   = 32'h00000000;
        three_in = 32'h87654321;
        signal   = 2'b11;
        $display("Test Case %0d: Selecting three_in (signal=11)", test_num);
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        zero_in  = 32'hFFFFFFFF;
        one_in   = 32'hAAAAAAAA;
        two_in   = 32'h55555555;
        three_in = 32'h00000000;
        signal   = 2'b00;
        $display("Test Case %0d: High bits check (signal=00)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        zero_in  = 32'hFFFFFFFF;
        one_in   = 32'hAAAAAAAA;
        two_in   = 32'h55555555;
        three_in = 32'h00000000;
        signal   = 2'b01;
        $display("Test Case %0d: Pattern A check (signal=01)", test_num);
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        zero_in  = 32'hFFFFFFFF;
        one_in   = 32'hAAAAAAAA;
        two_in   = 32'h55555555;
        three_in = 32'h00000000;
        signal   = 2'b10;
        $display("Test Case %0d: Pattern 5 check (signal=10)", test_num);
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        zero_in  = 32'hFFFFFFFF;
        one_in   = 32'hAAAAAAAA;
        two_in   = 32'h55555555;
        three_in = 32'h00000000;
        signal   = 2'b11;
        $display("Test Case %0d: All zeros check (signal=11)", test_num);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_mux_out;
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
