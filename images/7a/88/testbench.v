`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] c0_in;
    reg [63:0] c1_in;
    reg [63:0] c2_in;
    reg [63:0] c3_in;
    reg clk;
    wire [63:0] c0_down;
    wire [63:0] c0_up;
    wire [63:0] c1_down;
    wire [63:0] c1_up;
    wire [63:0] c2_down;
    wire [63:0] c2_up;
    wire [63:0] c3_down;
    wire [63:0] c3_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c0_in(c0_in),
        .c1_in(c1_in),
        .c2_in(c2_in),
        .c3_in(c3_in),
        .clk(clk),
        .c0_down(c0_down),
        .c0_up(c0_up),
        .c1_down(c1_down),
        .c1_up(c1_up),
        .c2_down(c2_down),
        .c2_up(c2_up),
        .c3_down(c3_down),
        .c3_up(c3_up)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            c0_in = 64'h0;
            c1_in = 64'h0;
            c2_in = 64'h0;
            c3_in = 64'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Incremental Values", test_num);
            c0_in = 64'h1;
            c1_in = 64'h2;
            c2_in = 64'h3;
            c3_in = 64'h4;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h1, 64'h2, 64'h2, 64'h3, 64'h3, 64'h4, 64'h4, 64'h1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Unique Hex Patterns", test_num);
            c0_in = 64'hDEADBEEFDEADBEEF;
            c1_in = 64'hCAFEBABECAFEBABE;
            c2_in = 64'hFACEFEEDFACEFEED;
            c3_in = 64'hFEEDFACEFEEDFACE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hDEADBEEFDEADBEEF, 64'hCAFEBABECAFEBABE,
                          64'hCAFEBABECAFEBABE, 64'hFACEFEEDFACEFEED,
                          64'hFACEFEEDFACEFEED, 64'hFEEDFACEFEEDFACE,
                          64'hFEEDFACEFEEDFACE, 64'hDEADBEEFDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: All Zeros", test_num);
            c0_in = 64'h0;
            c1_in = 64'h0;
            c2_in = 64'h0;
            c3_in = 64'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0, 64'h0, 64'h0, 64'h0, 64'h0, 64'h0, 64'h0, 64'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: All Ones", test_num);
            c0_in = 64'hFFFFFFFFFFFFFFFF;
            c1_in = 64'hFFFFFFFFFFFFFFFF;
            c2_in = 64'hFFFFFFFFFFFFFFFF;
            c3_in = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF,
                          64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF,
                          64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF,
                          64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Alternating Bit Patterns", test_num);
            c0_in = 64'hAAAAAAAAAAAAAAAA;
            c1_in = 64'h5555555555555555;
            c2_in = 64'h0F0F0F0F0F0F0F0F;
            c3_in = 64'hF0F0F0F0F0F0F0F0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555,
                          64'h5555555555555555, 64'h0F0F0F0F0F0F0F0F,
                          64'h0F0F0F0F0F0F0F0F, 64'hF0F0F0F0F0F0F0F0,
                          64'hF0F0F0F0F0F0F0F0, 64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Sequential Update Check", test_num);

            c0_in = 64'hA; c1_in = 64'hB; c2_in = 64'hC; c3_in = 64'hD;
            @(posedge clk);
            #2;

            c0_in = 64'h10; c1_in = 64'h20; c2_in = 64'h30; c3_in = 64'h40;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h10, 64'h20, 64'h20, 64'h30, 64'h30, 64'h40, 64'h40, 64'h10);
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
        input [63:0] expected_c0_down;
        input [63:0] expected_c0_up;
        input [63:0] expected_c1_down;
        input [63:0] expected_c1_up;
        input [63:0] expected_c2_down;
        input [63:0] expected_c2_up;
        input [63:0] expected_c3_down;
        input [63:0] expected_c3_up;
        begin
            if (expected_c0_down === (expected_c0_down ^ c0_down ^ expected_c0_down) &&
                expected_c0_up === (expected_c0_up ^ c0_up ^ expected_c0_up) &&
                expected_c1_down === (expected_c1_down ^ c1_down ^ expected_c1_down) &&
                expected_c1_up === (expected_c1_up ^ c1_up ^ expected_c1_up) &&
                expected_c2_down === (expected_c2_down ^ c2_down ^ expected_c2_down) &&
                expected_c2_up === (expected_c2_up ^ c2_up ^ expected_c2_up) &&
                expected_c3_down === (expected_c3_down ^ c3_down ^ expected_c3_down) &&
                expected_c3_up === (expected_c3_up ^ c3_up ^ expected_c3_up)) begin
                $display("PASS");
                $display("  Outputs: c0_down=%h, c0_up=%h, c1_down=%h, c1_up=%h, c2_down=%h, c2_up=%h, c3_down=%h, c3_up=%h",
                         c0_down, c0_up, c1_down, c1_up, c2_down, c2_up, c3_down, c3_up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0_down=%h, c0_up=%h, c1_down=%h, c1_up=%h, c2_down=%h, c2_up=%h, c3_down=%h, c3_up=%h",
                         expected_c0_down, expected_c0_up, expected_c1_down, expected_c1_up, expected_c2_down, expected_c2_up, expected_c3_down, expected_c3_up);
                $display("  Got:      c0_down=%h, c0_up=%h, c1_down=%h, c1_up=%h, c2_down=%h, c2_up=%h, c3_down=%h, c3_up=%h",
                         c0_down, c0_up, c1_down, c1_up, c2_down, c2_up, c3_down, c3_up);
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
        $dumpvars(0,c0_in, c1_in, c2_in, c3_in, clk, c0_down, c0_up, c1_down, c1_up, c2_down, c2_up, c3_down, c3_up);
    end

endmodule
