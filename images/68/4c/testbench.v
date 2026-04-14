`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rx_access;
    reg rx_burst;
    reg [103:0] rx_packet;
    reg test_mode;
    wire erx_access;
    wire [103:0] erx_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx_access(rx_access),
        .rx_burst(rx_burst),
        .rx_packet(rx_packet),
        .test_mode(test_mode),
        .erx_access(erx_access),
        .erx_packet(erx_packet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rx_access = 0;
            rx_burst = 0;
            test_mode = 0;
            rx_packet = 104'b0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Access (Incrementing)", test_num);
            reset_dut();

            rx_packet = {40'hA1_B2C3_D4E5, 32'h0, 32'hFFFF_FFFF};
            rx_access = 1;
            rx_burst  = 0;
            test_mode = 0;

            @(posedge clk);
            #1;

            shadow_addr = shadow_addr + 4;
            #1;

            check_outputs(1'b1, {40'hA1_B2C3_D4E5, shadow_addr, 32'h0000_0000});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Burst Access (Increment by 8)", test_num);
            reset_dut();

            rx_packet = {40'h12_3456_7890, 32'h0, 32'h0000_1111};
            rx_access = 1;
            rx_burst  = 1;
            test_mode = 0;

            @(posedge clk);
            #1;
            shadow_addr = shadow_addr + 8;
            #1;

            check_outputs(1'b1, {40'h12_3456_7890, shadow_addr, 32'h0000_0000});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Test Mode (Should block erx_access)", test_num);
            reset_dut();

            rx_packet = {40'hFF_FFFF_FFFF, 32'h0, 32'h0};
            rx_access = 1;
            rx_burst  = 0;
            test_mode = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 104'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence of mixed Normal/Burst", test_num);
            reset_dut();


            rx_packet = {40'hCA_FECA_FE01, 32'h0, 32'h0};
            rx_access = 1; rx_burst = 0; test_mode = 0;
            @(posedge clk);
            shadow_addr = shadow_addr + 4;


            rx_packet = {40'hDE_ADBE_EF02, 32'h0, 32'h0};
            rx_access = 1; rx_burst = 1; test_mode = 0;
            @(posedge clk);
            shadow_addr = shadow_addr + 8;

            #1;
            #1;

            check_outputs(1'b1, {40'hDE_ADBE_EF02, shadow_addr, 32'h0000_0000});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State", test_num);
            reset_dut();

            rx_access = 0;
            test_mode = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 104'h0);
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
        input expected_erx_access;
        input [103:0] expected_erx_packet;
        begin
            if (expected_erx_access === (expected_erx_access ^ erx_access ^ expected_erx_access) &&
                expected_erx_packet === (expected_erx_packet ^ erx_packet ^ expected_erx_packet)) begin
                $display("PASS");
                $display("  Outputs: erx_access=%b, erx_packet=%h",
                         erx_access, erx_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: erx_access=%b, erx_packet=%h",
                         expected_erx_access, expected_erx_packet);
                $display("  Got:      erx_access=%b, erx_packet=%h",
                         erx_access, erx_packet);
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
        $dumpvars(0,clk, rx_access, rx_burst, rx_packet, test_mode, erx_access, erx_packet);
    end

endmodule
