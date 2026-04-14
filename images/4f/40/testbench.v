`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [79:0] a;
    reg [79:0] b;
    reg clk;
    wire [159:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 80'd0;
            b = 80'd0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 80'd0;
            b = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
            repeat (5) @(posedge clk);
            $display("Test %0d: Zero Multiplication", test_num);
            #1;

            check_outputs(160'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 80'd1;
            b = 80'h1234_5678_9ABC_DEF0_1234;
            repeat (5) @(posedge clk);
            $display("Test %0d: Unit Multiplication", test_num);
            #1;

            check_outputs(160'h1234_5678_9ABC_DEF0_1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 80'd1000;
            b = 80'd500;
            repeat (5) @(posedge clk);
            $display("Test %0d: Small Constant Multiplication", test_num);
            #1;

            check_outputs(160'd500000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = {40'h1, 40'h0};
            b = {40'h1, 40'h0};
            repeat (5) @(posedge clk);
            $display("Test %0d: 2^40 * 2^40", test_num);

            #1;


            check_outputs(160'h1_0000_0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
            b = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
            repeat (5) @(posedge clk);
            $display("Test %0d: Maximum Values", test_num);

            #1;


            check_outputs(160'hFFFF_FFFF_FFFF_FFFF_FFFE_0000_0000_0000_0000_0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 80'hFFFF_FFFF_FFFF_FFFF_FFFF;
            b = 80'h0000_0000_0000_0000_0001;
            repeat (5) @(posedge clk);
            $display("Test %0d: Full a * 1", test_num);
            #1;

            check_outputs(160'hFFFF_FFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 80'hABCD_EF01_2345_6789_AAAA;
            b = 80'h5555_4444_3333_2222_1111;
            repeat (5) @(posedge clk);
            $display("Test %0d: Hex Pattern Multiplication", test_num);


            #1;



            check_outputs(160'h3938_504E_4111_431A_3D93_4C01_F4F1_E5A3_7393_9AAA);
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
        input [159:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, clk, p);
    end

endmodule
