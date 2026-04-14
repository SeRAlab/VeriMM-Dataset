`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [80:0] d_in;
    reg [7:0] sh;
    reg z54;
    wire [80:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_in(d_in),
        .sh(sh),
        .z54(z54),
        .d_out(d_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (sh=0, z54=0)", test_num);
            d_in = 81'h1FFFFFFFFFFFFFFFFFFFF;
            sh = 8'd0;
            z54 = 1'b0;
            #10;
            #1;

            check_outputs(81'h1FFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zeroing active (sh=0, z54=1)", test_num);
            d_in = 81'h1FFFFFFFFFFFFFFFFFFFF;
            sh = 8'd0;
            z54 = 1'b1;
            #10;


            #1;



            check_outputs(81'h1FFFFFFC0000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left Rotate 1 (sh=1, z54=0)", test_num);
            d_in = 81'h000000000000000000001;
            sh = 8'd1;
            z54 = 1'b0;
            #10;
            #1;

            check_outputs(81'h000000000000000000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift to bit 53 (sh=53, z54=0)", test_num);
            d_in = 81'h000000000000000000001;
            sh = 8'd53;
            z54 = 1'b0;
            #10;

            #1;


            check_outputs(81'h000000020000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift to bit 53 and Zero (sh=53, z54=1)", test_num);
            d_in = 81'h000000000000000000001;
            sh = 8'd53;
            z54 = 1'b1;
            #10;
            #1;

            check_outputs(81'h000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift to bit 54 (sh=54, z54=1)", test_num);
            d_in = 81'h000000000000000000001;
            sh = 8'd54;
            z54 = 1'b1;
            #10;

            #1;


            check_outputs(81'h000000040000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap Around (sh=1, bit 80)", test_num);
            d_in = 81'h100000000000000000000;
            sh = 8'd1;
            z54 = 1'b0;
            #10;
            #1;

            check_outputs(81'h000000000000000000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Rotation (sh=81)", test_num);
            d_in = 81'h0ABCDE0123456789ABCDE;
            sh = 8'd81;
            z54 = 1'b0;
            #10;
            #1;

            check_outputs(81'h0ABCDE0123456789ABCDE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex pattern (sh=40, z54=1)", test_num);



            d_in = 81'h000000000040000000001;
            sh = 8'd40;
            z54 = 1'b1;
            #10;
            #1;

            check_outputs(81'h000000000000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 80 (Max unique shift)", test_num);
            d_in = 81'h000000000000000000001;
            sh = 8'd80;
            z54 = 1'b0;
            #10;
            #1;

            check_outputs(81'h100000000000000000000);
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
        testcase010();
        
        
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
        input [80:0] expected_d_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
