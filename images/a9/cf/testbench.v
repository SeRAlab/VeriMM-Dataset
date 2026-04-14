`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] d;
    reg ld;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .ld(ld),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            ld <= 0;
            d <= 64'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Load Operation", test_num);
            reset_dut();

            d <= 64'hA5A5A5A5_5A5A5A5A;
            ld <= 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hA5A5A5A5_5A5A5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Disabled (Hold value)", test_num);
            reset_dut();


            d <= 64'h12345678_9ABCDEF0;
            ld <= 1;
            @(posedge clk);
            #1;


            ld <= 0;
            d <= 64'hFFFFFFFF_FFFFFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(64'h12345678_9ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load All Ones", test_num);
            reset_dut();

            d <= 64'hFFFFFFFF_FFFFFFFF;
            ld <= 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hFFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load All Zeros", test_num);
            reset_dut();


            d <= 64'hFFFFFFFF_FFFFFFFF;
            ld <= 1;
            @(posedge clk);


            d <= 64'h00000000_00000000;
            ld <= 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h00000000_00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Successive Loads", test_num);
            reset_dut();

            ld <= 1;
            d <= 64'hCAFE_BABE_DEAD_BEEF;
            @(posedge clk);
            #1;
            d <= 64'h0123_4567_89AB_CDEF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h0123_4567_89AB_CDEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input change without clock edge", test_num);
            reset_dut();


            ld <= 1;
            d <= 64'h1111_1111_1111_1111;
            @(posedge clk);
            #1;


            ld <= 1;
            d <= 64'hEEEE_EEEE_EEEE_EEEE;
            #2;


            #1;



            check_outputs(64'h1111_1111_1111_1111);
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
        input [63:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, ld, q);
    end

endmodule
