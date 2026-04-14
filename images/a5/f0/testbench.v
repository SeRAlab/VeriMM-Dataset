`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CONTROL_ALUSRC;
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CONTROL_ALUSRC(CONTROL_ALUSRC),
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select input A (ALUSRC=0)", test_num);
            a = 64'hFEDCBA9876543210;
            b = 64'h0123456789ABCDEF;
            CONTROL_ALUSRC = 1'b0;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select input B (ALUSRC=1)", test_num);
            a = 64'hFEDCBA9876543210;
            b = 64'h0123456789ABCDEF;
            CONTROL_ALUSRC = 1'b1;
            #1;

            check_outputs(64'h0123456789ABCDEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select All Zeros (ALUSRC=0)", test_num);
            a = 64'h0000000000000000;
            b = 64'hFFFFFFFFFFFFFFFF;
            CONTROL_ALUSRC = 1'b0;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select All Ones (ALUSRC=1)", test_num);
            a = 64'h0000000000000000;
            b = 64'hFFFFFFFFFFFFFFFF;
            CONTROL_ALUSRC = 1'b1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits Select A (ALUSRC=0)", test_num);
            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h5555555555555555;
            CONTROL_ALUSRC = 1'b0;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating Bits Select B (ALUSRC=1)", test_num);
            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h5555555555555555;
            CONTROL_ALUSRC = 1'b1;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Large Value Selection A (ALUSRC=0)", test_num);
            a = 64'hFFFFFFFF00000000;
            b = 64'h00000000FFFFFFFF;
            CONTROL_ALUSRC = 1'b0;
            #1;

            check_outputs(64'hFFFFFFFF00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Large Value Selection B (ALUSRC=1)", test_num);
            a = 64'hFFFFFFFF00000000;
            b = 64'h00000000FFFFFFFF;
            CONTROL_ALUSRC = 1'b1;
            #1;

            check_outputs(64'h00000000FFFFFFFF);
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
