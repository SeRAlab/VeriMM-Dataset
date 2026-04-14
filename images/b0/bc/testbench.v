`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    reg [7:0] mask;
    wire [7:0] dout;
    wire [3:0] ndout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .mask(mask),
        .dout(dout),
        .ndout(ndout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Mask", test_num);
        din = 8'hFF;
        mask = 8'h00;
        #1;

        check_outputs(8'h00, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Bits Selected", test_num);
        din = 8'h5A;
        mask = 8'hFF;
        #1;

        check_outputs(8'h5A, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lower Nibble Selection", test_num);
        din = 8'hA5;
        mask = 8'h0F;

        #1;


        check_outputs(8'h05, 4'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Upper Nibble Selection (Pack to LSB)", test_num);
        din = 8'hA5;
        mask = 8'hF0;

        #1;


        check_outputs(8'h0A, 4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Mask 10101010", test_num);
        din = 8'hCC;
        mask = 8'hAA;


        #1;



        check_outputs(8'h0A, 4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Mask 01010101", test_num);
        din = 8'hCC;
        mask = 8'h55;


        #1;



        check_outputs(8'h0A, 4'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse Pattern", test_num);
        din = 8'b10110111;
        mask = 8'b10000001;


        #1;



        check_outputs(8'h03, 4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse Pattern Resulting in Zeros", test_num);
        din = 8'b01111110;
        mask = 8'b10000001;


        #1;



        check_outputs(8'h00, 4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit (LSB)", test_num);
        din = 8'hFE;
        mask = 8'h01;

        #1;


        check_outputs(8'h00, 4'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Bit (MSB)", test_num);
        din = 8'h80;
        mask = 8'h80;

        #1;


        check_outputs(8'h01, 4'd1);
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
        input [7:0] expected_dout;
        input [3:0] expected_ndout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_ndout === (expected_ndout ^ ndout ^ expected_ndout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, ndout=%h",
                         dout, ndout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, ndout=%h",
                         expected_dout, expected_ndout);
                $display("  Got:      dout=%h, ndout=%h",
                         dout, ndout);
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
