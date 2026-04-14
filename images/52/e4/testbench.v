`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] channel;
    reg clk;
    reg reset;
    reg [15:0] xadc_data;
    reg xadc_data_ready;
    wire [15:0] xadc_vaux0_data;
    wire xadc_vaux0_ready;
    wire [15:0] xadc_vaux8_data;
    wire xadc_vaux8_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel(channel),
        .clk(clk),
        .reset(reset),
        .xadc_data(xadc_data),
        .xadc_data_ready(xadc_data_ready),
        .xadc_vaux0_data(xadc_vaux0_data),
        .xadc_vaux0_ready(xadc_vaux0_ready),
        .xadc_vaux8_data(xadc_vaux8_data),
        .xadc_vaux8_ready(xadc_vaux8_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel = 5'b0;
            xadc_data = 16'b0;
            xadc_data_ready = 1'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Route Data to Vaux0", test_num);
            reset_dut();
            channel = 5'h10;
            xadc_data = 16'hABCD;
            xadc_data_ready = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD, 1'b1, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Route Data to Vaux8", test_num);
            reset_dut();
            channel = 5'h18;
            xadc_data = 16'h55AA;
            xadc_data_ready = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0, 16'h55AA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Ready Low (No Storage)", test_num);
            reset_dut();
            channel = 5'h10;
            xadc_data = 16'hFFFF;
            xadc_data_ready = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unmapped Channel (5'h05)", test_num);
            reset_dut();
            channel = 5'h05;
            xadc_data = 16'h1234;
            xadc_data_ready = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Routing and Storage", test_num);
            reset_dut();


            channel = 5'h10;
            xadc_data = 16'h1111;
            xadc_data_ready = 1'b1;
            @(posedge clk);
            #1;


            channel = 5'h18;
            xadc_data = 16'h8888;
            xadc_data_ready = 1'b1;
            @(posedge clk);
            #1;





            #1;






            check_outputs(16'h1111, 1'b0, 16'h8888, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Update Existing Data", test_num);
            reset_dut();

            channel = 5'h10;
            xadc_data = 16'hAAAA;
            xadc_data_ready = 1'b1;
            @(posedge clk);
            #1;

            xadc_data = 16'hBBBB;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBBBB, 1'b1, 16'h0000, 1'b0);
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
        input [15:0] expected_xadc_vaux0_data;
        input expected_xadc_vaux0_ready;
        input [15:0] expected_xadc_vaux8_data;
        input expected_xadc_vaux8_ready;
        begin
            if (expected_xadc_vaux0_data === (expected_xadc_vaux0_data ^ xadc_vaux0_data ^ expected_xadc_vaux0_data) &&
                expected_xadc_vaux0_ready === (expected_xadc_vaux0_ready ^ xadc_vaux0_ready ^ expected_xadc_vaux0_ready) &&
                expected_xadc_vaux8_data === (expected_xadc_vaux8_data ^ xadc_vaux8_data ^ expected_xadc_vaux8_data) &&
                expected_xadc_vaux8_ready === (expected_xadc_vaux8_ready ^ xadc_vaux8_ready ^ expected_xadc_vaux8_ready)) begin
                $display("PASS");
                $display("  Outputs: xadc_vaux0_data=%h, xadc_vaux0_ready=%b, xadc_vaux8_data=%h, xadc_vaux8_ready=%b",
                         xadc_vaux0_data, xadc_vaux0_ready, xadc_vaux8_data, xadc_vaux8_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xadc_vaux0_data=%h, xadc_vaux0_ready=%b, xadc_vaux8_data=%h, xadc_vaux8_ready=%b",
                         expected_xadc_vaux0_data, expected_xadc_vaux0_ready, expected_xadc_vaux8_data, expected_xadc_vaux8_ready);
                $display("  Got:      xadc_vaux0_data=%h, xadc_vaux0_ready=%b, xadc_vaux8_data=%h, xadc_vaux8_ready=%b",
                         xadc_vaux0_data, xadc_vaux0_ready, xadc_vaux8_data, xadc_vaux8_ready);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,channel, clk, reset, xadc_data, xadc_data_ready, xadc_vaux0_data, xadc_vaux0_ready, xadc_vaux8_data, xadc_vaux8_ready);
    end

endmodule
