`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] din0;
    reg [31:0] din1;
    reg [31:0] din2;
    reg [31:0] din3;
    reg [31:0] din4;
    reg [31:0] din5;
    reg [2:0] op;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .din4(din4),
        .din5(din5),
        .op(op),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din0 (op=0)", test_num);
            din0 = 32'hAAAA_5555; din1 = 32'h0; din2 = 32'h0;
            din3 = 32'h0; din4 = 32'h0; din5 = 32'h0;
            op = 3'd0;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din1 (op=1)", test_num);
            din0 = 32'h0; din1 = 32'h1234_5678; din2 = 32'h0;
            din3 = 32'h0; din4 = 32'h0; din5 = 32'h0;
            op = 3'd1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din2 (op=2)", test_num);
            din0 = 32'hFFFF_FFFF; din1 = 32'h0; din2 = 32'hDEAD_BEEF;
            din3 = 32'h0; din4 = 32'h0; din5 = 32'h0;
            op = 3'd2;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din3 (op=3)", test_num);
            din0 = 32'h0; din1 = 32'h0; din2 = 32'h0;
            din3 = 32'hCAFE_BABE; din4 = 32'h0; din5 = 32'h0;
            op = 3'd3;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din4 (op=4)", test_num);
            din0 = 32'h1; din1 = 32'h2; din2 = 32'h3;
            din3 = 32'h4; din4 = 32'h8888_9999; din5 = 32'h6;
            op = 3'd4;
            #1;

            check_outputs(32'h8888_9999);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din5 (op=5)", test_num);
            din0 = 32'h0; din1 = 32'h0; din2 = 32'h0;
            din3 = 32'h0; din4 = 32'h0; din5 = 32'h55AA_CC33;
            op = 3'd5;
            #1;

            check_outputs(32'h55AA_CC33);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out of range (op=6)", test_num);
            din0 = 32'hFFFF_FFFF; din1 = 32'hFFFF_FFFF; din2 = 32'hFFFF_FFFF;
            din3 = 32'hFFFF_FFFF; din4 = 32'hFFFF_FFFF; din5 = 32'hFFFF_FFFF;
            op = 3'd6;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Out of range (op=7)", test_num);
            din0 = 32'h1234_5678; din5 = 32'h8765_4321;
            op = 3'd7;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic data check", test_num);
            din3 = 32'h0000_0001;
            op = 3'd3;
            #1;

            check_outputs(32'h0000_0001);
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
        testcase009();
        
        
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
