`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [2:0] din_data;
    reg din_valid;
    reg dout0_ready;
    reg dout1_ready;
    reg rst;
    wire din_ready;
    wire dout0_data;
    wire dout0_valid;
    wire [1:0] dout1_data;
    wire dout1_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din_data(din_data),
        .din_valid(din_valid),
        .dout0_ready(dout0_ready),
        .dout1_ready(dout1_ready),
        .rst(rst),
        .din_ready(din_ready),
        .dout0_data(dout0_data),
        .dout0_valid(dout0_valid),
        .dout1_data(dout1_data),
        .dout1_valid(dout1_valid)
    );
    task testcase001;

        begin
            test_num = 1;

            rst = 1; din_valid = 0; din_data = 0; dout0_ready = 0; dout1_ready = 0;
            @(posedge clk);
            rst = 0;

            din_valid = 1;
            din_data = 3'b001;
            dout0_ready = 1;
            dout1_ready = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 2'b01, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            rst = 1; @(posedge clk); rst = 0;

            din_valid = 1;
            din_data = 3'b110;
            dout0_ready = 0;
            dout1_ready = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 2'b10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            rst = 1; @(posedge clk); rst = 0;

            din_valid = 1;
            din_data = 3'b011;
            dout0_ready = 0;
            dout1_ready = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 2'b11, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            rst = 1; @(posedge clk); rst = 0;

            din_valid = 1;
            din_data = 3'b111;
            dout0_ready = 1;
            dout1_ready = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 2'b11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            rst = 1; @(posedge clk); rst = 0;

            din_valid = 0;
            din_data = 3'b001;
            dout0_ready = 1;
            dout1_ready = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 2'b01, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            rst = 1;
            din_valid = 1;
            din_data = 3'b111;
            dout0_ready = 1;
            dout1_ready = 1;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 2'b00, 1'b0);
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
        input expected_din_ready;
        input expected_dout0_data;
        input expected_dout0_valid;
        input [1:0] expected_dout1_data;
        input expected_dout1_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_dout0_data === (expected_dout0_data ^ dout0_data ^ expected_dout0_data) &&
                expected_dout0_valid === (expected_dout0_valid ^ dout0_valid ^ expected_dout0_valid) &&
                expected_dout1_data === (expected_dout1_data ^ dout1_data ^ expected_dout1_data) &&
                expected_dout1_valid === (expected_dout1_valid ^ dout1_valid ^ expected_dout1_valid)) begin
                $display("PASS");
                $display("  Outputs: din_ready=%b, dout0_data=%b, dout0_valid=%b, dout1_data=%h, dout1_valid=%b",
                         din_ready, dout0_data, dout0_valid, dout1_data, dout1_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_ready=%b, dout0_data=%b, dout0_valid=%b, dout1_data=%h, dout1_valid=%b",
                         expected_din_ready, expected_dout0_data, expected_dout0_valid, expected_dout1_data, expected_dout1_valid);
                $display("  Got:      din_ready=%b, dout0_data=%b, dout0_valid=%b, dout1_data=%h, dout1_valid=%b",
                         din_ready, dout0_data, dout0_valid, dout1_data, dout1_valid);
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
