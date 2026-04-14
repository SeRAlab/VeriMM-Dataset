`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg HIN;
    reg PCLK;
    reg VIN;
    wire B;
    wire G;
    wire HSYNC;
    wire R;
    wire VSYNC;
    wire XCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .HIN(HIN),
        .PCLK(PCLK),
        .VIN(VIN),
        .B(B),
        .G(G),
        .HSYNC(HSYNC),
        .R(R),
        .VSYNC(VSYNC),
        .XCLK(XCLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D = 8'h00;
            HIN = 0;
            PCLK = 0;
            VIN = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Sync Signal Pass-through...");
            reset_dut();
            test_num = 1;

            @(posedge CLK);
            HIN = 1;
            VIN = 1;
            D = 8'h00;
            PCLK = 1;

            repeat(2) @(posedge CLK);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Red Channel Mapping...");
            reset_dut();
            test_num = 2;

            @(posedge CLK);
            HIN = 1;
            VIN = 1;
            D = 8'b10000000;
            PCLK = 1;

            repeat(2) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Green Channel Mapping...");
            reset_dut();
            test_num = 3;

            @(posedge CLK);
            HIN = 1;
            VIN = 1;
            D = 8'b01000000;
            PCLK = 1;

            repeat(2) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Blue Channel Mapping...");
            reset_dut();
            test_num = 4;

            @(posedge CLK);
            HIN = 1;
            VIN = 1;
            D = 8'b00100000;
            PCLK = 1;

            repeat(2) @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Sync Low State...");
            reset_dut();
            test_num = 5;

            @(posedge CLK);
            HIN = 0;
            VIN = 0;
            D = 8'hFF;
            PCLK = 0;

            repeat(2) @(posedge CLK);
            #1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_B;
        input expected_G;
        input expected_HSYNC;
        input expected_R;
        input expected_VSYNC;
        input expected_XCLK;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_HSYNC === (expected_HSYNC ^ HSYNC ^ expected_HSYNC) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_VSYNC === (expected_VSYNC ^ VSYNC ^ expected_VSYNC) &&
                expected_XCLK === (expected_XCLK ^ XCLK ^ expected_XCLK)) begin
                $display("PASS");
                $display("  Outputs: B=%b, G=%b, HSYNC=%b, R=%b, VSYNC=%b, XCLK=%b",
                         B, G, HSYNC, R, VSYNC, XCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%b, G=%b, HSYNC=%b, R=%b, VSYNC=%b, XCLK=%b",
                         expected_B, expected_G, expected_HSYNC, expected_R, expected_VSYNC, expected_XCLK);
                $display("  Got:      B=%b, G=%b, HSYNC=%b, R=%b, VSYNC=%b, XCLK=%b",
                         B, G, HSYNC, R, VSYNC, XCLK);
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
        $dumpvars(0,CLK, D, HIN, PCLK, VIN, B, G, HSYNC, R, VSYNC, XCLK);
    end

endmodule
