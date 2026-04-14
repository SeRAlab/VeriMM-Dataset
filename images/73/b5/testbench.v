`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] din_0;
    reg [31:0] din_1;
    reg [31:0] din_2;
    reg [31:0] din_3;
    reg [1:0] sel;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_0(din_0),
        .din_1(din_1),
        .din_2(din_2),
        .din_3(din_3),
        .sel(sel),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select din_0 (sel=00)", test_num);
            sel = 2'b00;
            din_0 = 32'h12345678;
            din_1 = 32'hFFFFFFFF;
            din_2 = 32'h00000000;
            din_3 = 32'hA5A5A5A5;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select din_1 (sel=01)", test_num);
            sel = 2'b01;
            din_0 = 32'h11111111;
            din_1 = 32'h22222222;
            din_2 = 32'h33333333;
            din_3 = 32'h44444444;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select din_2 (sel=10)", test_num);
            sel = 2'b10;
            din_0 = 32'hAAAAAAAA;
            din_1 = 32'hBBBBBBBB;
            din_2 = 32'hCCCCCCCC;
            din_3 = 32'hDDDDDDDD;
            #1;

            check_outputs(32'hCCCCCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select din_3 (sel=11)", test_num);
            sel = 2'b11;
            din_0 = 32'h0000CAFE;
            din_1 = 32'h0000BABE;
            din_2 = 32'h0000FACE;
            din_3 = 32'h0000FEED;
            #1;

            check_outputs(32'h0000FEED);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Change non-selected inputs while sel=00", test_num);
            sel = 2'b00;
            din_0 = 32'hDEADBEEF;
            din_1 = 32'h0;
            din_2 = 32'h0;
            din_3 = 32'h0;
            #5;
            din_1 = 32'hFFFFFFFF;
            din_2 = 32'hFFFFFFFF;
            din_3 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Check invalid sel behavior (sel=2'bxx)", test_num);
            sel = 2'bxx;
            din_0 = 32'h11111111;
            din_1 = 32'h22222222;
            din_2 = 32'h33333333;
            din_3 = 32'h44444444;
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
