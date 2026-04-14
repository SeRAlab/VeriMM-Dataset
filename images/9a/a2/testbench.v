`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg active;
    reg clk_x2;
    reg [7:0] data;
    wire [15:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .active(active),
        .clk_x2(clk_x2),
        .data(data),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        clk_x2 = 0;
        forever #5 clk_x2 = ~clk_x2;
    end

        task reset_dut;

    begin
        active = 0;
        data = 8'h00;
        repeat(3) @(posedge clk_x2);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic 0x1234 conversion", test_num);
        reset_dut();

        @(negedge clk_x2);
        active = 1; data = 8'h12;
        @(negedge clk_x2);
        active = 1; data = 8'h34;
        @(negedge clk_x2);
        active = 0;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating pattern 0xAA55", test_num);
        reset_dut();

        @(negedge clk_x2);
        active = 1; data = 8'hAA;
        @(negedge clk_x2);
        active = 1; data = 8'h55;
        @(negedge clk_x2);
        active = 0;

        #1;


        check_outputs(16'hAA55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Continuous Stream (Two pairs)", test_num);
        reset_dut();

        @(negedge clk_x2);
        active = 1; data = 8'h11; @(negedge clk_x2);
        active = 1; data = 8'h22; @(negedge clk_x2);
        active = 1; data = 8'h33; @(negedge clk_x2);
        active = 1; data = 8'h44; @(negedge clk_x2);
        active = 0;

        #1;


        check_outputs(16'h3344);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupted Active Signal", test_num);
        reset_dut();

        @(negedge clk_x2);
        active = 1; data = 8'hDE;
        @(negedge clk_x2);
        active = 0; data = 8'hFF;
        repeat(2) @(negedge clk_x2);
        active = 1; data = 8'hAD;
        @(negedge clk_x2);
        active = 0;

        #1;


        check_outputs(16'hDEAD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Value - All Zeros", test_num);
        reset_dut();

        @(negedge clk_x2);
        active = 1; data = 8'h00; @(negedge clk_x2);
        active = 1; data = 8'h00; @(negedge clk_x2);
        active = 0;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Value - All Ones", test_num);
        reset_dut();

        @(negedge clk_x2);
        active = 1; data = 8'hFF; @(negedge clk_x2);
        active = 1; data = 8'hFF; @(negedge clk_x2);
        active = 0;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inactive Data Handling", test_num);
        reset_dut();


        @(negedge clk_x2);
        active = 1; data = 8'hBE; @(negedge clk_x2);
        active = 1; data = 8'hEF; @(negedge clk_x2);


        active = 0; data = 8'h12; @(negedge clk_x2);
        data = 8'h34; @(negedge clk_x2);

        #1;


        check_outputs(16'hBEEF);
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
        input [15:0] expected_rgb;
        begin
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
        $dumpvars(0,active, clk_x2, data, rgb);
    end

endmodule
