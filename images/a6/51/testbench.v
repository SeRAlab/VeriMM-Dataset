`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] din_a;
    reg [11:0] din_b;
    reg [11:0] din_c;
    reg [1:0] sel;
    wire [11:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_a(din_a),
        .din_b(din_b),
        .din_c(din_c),
        .sel(sel),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select din_a (sel=00)", test_num);
            din_a = 12'hAAA;
            din_b = 12'hBBB;
            din_c = 12'hCCC;
            sel = 2'b00;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select din_b (sel=01)", test_num);
            din_a = 12'hAAA;
            din_b = 12'hBBB;
            din_c = 12'hCCC;
            sel = 2'b01;
            #1;

            check_outputs(12'hBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select din_c (sel=10)", test_num);
            din_a = 12'hAAA;
            din_b = 12'hBBB;
            din_c = 12'hCCC;
            sel = 2'b10;
            #1;

            check_outputs(12'hCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Invalid range (sel=11), should default to din_a", test_num);
            din_a = 12'hAAA;
            din_b = 12'hBBB;
            din_c = 12'hCCC;
            sel = 2'b11;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verify logic with different data patterns (sel=01)", test_num);
            din_a = 12'hF0F;
            din_b = 12'h0F0;
            din_c = 12'hFFF;
            sel = 2'b01;
            #1;

            check_outputs(12'h0F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Verify all zeros data selection (sel=10)", test_num);
            din_a = 12'hFFF;
            din_b = 12'hAAA;
            din_c = 12'h000;
            sel = 2'b10;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Verify default logic with high data values (sel=11)", test_num);
            din_a = 12'hFFF;
            din_b = 12'h123;
            din_c = 12'h456;
            sel = 2'b11;
            #1;

            check_outputs(12'hFFF);
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
        input [11:0] expected_dout;
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
