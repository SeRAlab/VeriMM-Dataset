`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] in0;
    reg [63:0] in1;
    reg [1:0] sel;
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
            $display("Test Case %0d: Select lower 32 bits of in0 (sel=00)", test_num);
            in0 = 64'hFEDCBA9876543210;
            in1 = 64'h0123456789ABCDEF;
            sel = 2'b00;
            #1;

            check_outputs(64'h0000000076543210);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select upper 32 bits of in0 (sel=01)", test_num);
            in0 = 64'hFEDCBA9876543210;
            in1 = 64'h0123456789ABCDEF;
            sel = 2'b01;
            #1;

            check_outputs(64'h00000000FEDCBA98);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select lower 32 bits of in1 (sel=10)", test_num);
            in0 = 64'hFEDCBA9876543210;
            in1 = 64'h0123456789ABCDEF;
            sel = 2'b10;
            #1;

            check_outputs(64'h0000000089ABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select upper 32 bits of in1 (sel=11)", test_num);
            in0 = 64'hFEDCBA9876543210;
            in1 = 64'h0123456789ABCDEF;
            sel = 2'b11;
            #1;

            check_outputs(64'h0000000001234567);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - All Fs in0, sel=00", test_num);
            in0 = 64'hFFFFFFFFFFFFFFFF;
            in1 = 64'h0000000000000000;
            sel = 2'b00;
            #1;

            check_outputs(64'h00000000FFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - All 0s in1, sel=11", test_num);
            in0 = 64'hFFFFFFFFFFFFFFFF;
            in1 = 64'h0000000000000000;
            sel = 2'b11;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern in1, sel=10", test_num);
            in0 = 64'h0;
            in1 = 64'hAAAAAAAAAAAAAAAA;
            sel = 2'b10;
            #1;

            check_outputs(64'h00000000AAAAAAAA);
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
