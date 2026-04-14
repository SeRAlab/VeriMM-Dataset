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
            din = 8'hFF;
            mask = 8'h00;
            #1;

            check_outputs(8'h00, 4'd0);
        end
        endtask

    task testcase002;

        begin
            din = 8'hA5;
            mask = 8'hFF;
            #1;

            check_outputs(8'hA5, 4'd8);
        end
        endtask

    task testcase003;

        begin
            din = 8'b10101010;
            mask = 8'b01010101;
            #1;

            check_outputs(8'b00000000, 4'd4);
        end
        endtask

    task testcase004;

        begin
            din = 8'b10101010;
            mask = 8'b10101010;
            #1;

            check_outputs(8'b00001111, 4'd4);
        end
        endtask

    task testcase005;

        begin
            din = 8'b11001100;
            mask = 8'b11110000;
            #1;

            check_outputs(8'b00001100, 4'd4);
        end
        endtask

    task testcase006;

        begin
            din = 8'b11001100;
            mask = 8'b00001111;
            #1;

            check_outputs(8'b00001100, 4'd4);
        end
        endtask

    task testcase007;

        begin
            din = 8'b10000000;
            mask = 8'b10000000;
            #1;

            check_outputs(8'b00000001, 4'd1);
        end
        endtask

    task testcase008;

        begin
            din = 8'b11110000;
            mask = 8'b10001001;
            #1;

            check_outputs(8'b00000100, 4'd3);
        end
        endtask

    task testcase009;

        begin
            din = 8'b10110110;
            mask = 8'b10100101;
            #1;

            check_outputs(8'b00001110, 4'd4);
        end
        endtask

    task testcase010;

        begin
            din = 8'b11100111;
            mask = 8'b11101111;
            #1;

            check_outputs(8'b01110111, 4'd7);
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
