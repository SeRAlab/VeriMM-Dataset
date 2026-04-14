`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] a1;
    reg [9:0] a2;
    reg ce;
    reg clk;
    reg [7:0] din;
    reg we;
    wire [7:0] dout1;
    wire [7:0] dout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a1(a1),
        .a2(a2),
        .ce(ce),
        .clk(clk),
        .din(din),
        .we(we),
        .dout1(dout1),
        .dout2(dout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            we = 0;
            a1 = 0;
            a2 = 0;
            din = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Basic Write and Dual Port Read", test_num);


            @(negedge clk);
            ce = 1; we = 1; a1 = 10'd10; din = 8'h55;
            @(negedge clk);

            we = 0; a1 = 10'd10; a2 = 10'd10;
            @(negedge clk);

            #1;


            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Simultaneous Dual Port Read", test_num);


            @(negedge clk);
            ce = 1; we = 1; a1 = 10'd100; din = 8'hAA;
            @(negedge clk);

            a1 = 10'd200; din = 8'hBB;
            @(negedge clk);

            we = 0; a1 = 10'd100; a2 = 10'd200;
            @(negedge clk);
            #1;

            check_outputs(8'hAA, 8'hBB);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Chip Enable (ce) Test", test_num);


            @(negedge clk);
            ce = 1; we = 1; a1 = 10'd50; din = 8'h11;
            @(negedge clk);

            ce = 0; we = 1; a1 = 10'd50; din = 8'h22;
            @(negedge clk);

            ce = 1; we = 0; a1 = 10'd50; a2 = 10'd50;
            @(negedge clk);

            #1;


            check_outputs(8'h11, 8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Write Enable (we) Test", test_num);


            @(negedge clk);
            ce = 1; we = 1; a1 = 10'd300; din = 8'hCC;
            @(negedge clk);

            we = 0; a1 = 10'd300; din = 8'hDD;
            @(negedge clk);

            a1 = 10'd300; a2 = 10'd300;
            @(negedge clk);

            #1;


            check_outputs(8'hCC, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Boundary Address Test", test_num);


            @(negedge clk);
            ce = 1; we = 1; a1 = 10'd0; din = 8'h01;
            @(negedge clk);

            a1 = 10'd1023; din = 8'hFE;
            @(negedge clk);

            we = 0; a1 = 10'd0; a2 = 10'd1023;
            @(negedge clk);
            #1;

            check_outputs(8'h01, 8'hFE);
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
        input [7:0] expected_dout1;
        input [7:0] expected_dout2;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h",
                         dout1, dout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h",
                         expected_dout1, expected_dout2);
                $display("  Got:      dout1=%h, dout2=%h",
                         dout1, dout2);
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
        $dumpvars(0,a1, a2, ce, clk, din, we, dout1, dout2);
    end

endmodule
