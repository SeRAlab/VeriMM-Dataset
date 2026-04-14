`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [104:0] i_w104;
    reg [39:0] i_w40;
    reg [4:0] i_w5;
    wire [104:0] o_w104;
    wire [39:0] o_w40;
    wire [4:0] o_w5;
    wire [4:0] o_w5_d1r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_w104(i_w104),
        .i_w40(i_w40),
        .i_w5(i_w5),
        .o_w104(o_w104),
        .o_w40(o_w40),
        .o_w5(o_w5),
        .o_w5_d1r(o_w5_d1r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            i_w5 = 5'b0;
            i_w40 = 40'b0;
            i_w104 = 105'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            i_w5 = 5'h1A;
            i_w40 = 40'hDEADBEEFCA;
            i_w104 = 105'h123456789ABCDEF0123456789A;


            @(posedge clk);
            #2;


            i_w5 = 5'h05;
            #1;

            $display("Testcase %0d: Basic Routing and Delay", test_num);
            #1;

            check_outputs(
                105'h123456789ABCDEF0123456789A,
                40'hDEADBEEFCA,
                5'h05,
                5'h1A
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            i_w5   = 5'h1F;
            i_w40  = {40{1'b1}};
            i_w104 = {105{1'b1}};

            @(posedge clk);
            #2;


            i_w5   = 5'h0;
            i_w40  = 40'h0;
            i_w104 = 105'h0;
            #1;

            $display("Testcase %0d: All-Ones Routing and Delay", test_num);
            #1;

            check_outputs(
                105'h0,
                40'h0,
                5'h0,
                5'h1F
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            i_w5 = 5'h11;
            @(posedge clk); #2;


            i_w5 = 5'h12;
            @(posedge clk); #2;


            i_w5 = 5'h13;
            @(posedge clk); #2;



            i_w5 = 5'h00;
            #1;

            $display("Testcase %0d: Sequential Delay Tracking", test_num);
            #1;

            check_outputs(
                105'h0,
                40'h0,
                5'h00,
                5'h13
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            i_w5   = 5'b10101;
            i_w40  = 40'hAAAAAAAAAAAAAAAA;
            i_w104 = 105'h1AAAAAAAAAAAAAAAAAAAAAAAAAA;

            @(posedge clk);
            #2;

            i_w5   = 5'b01010;
            i_w40  = 40'h5555555555;
            i_w104 = 105'h05555555555555555555555555;
            #1;

            $display("Testcase %0d: Alternating Patterns", test_num);
            #1;

            check_outputs(
                105'h05555555555555555555555555,
                40'h5555555555,
                5'b01010,
                5'b10101
            );
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
        input [104:0] expected_o_w104;
        input [39:0] expected_o_w40;
        input [4:0] expected_o_w5;
        input [4:0] expected_o_w5_d1r;
        begin
            if (expected_o_w104 === (expected_o_w104 ^ o_w104 ^ expected_o_w104) &&
                expected_o_w40 === (expected_o_w40 ^ o_w40 ^ expected_o_w40) &&
                expected_o_w5 === (expected_o_w5 ^ o_w5 ^ expected_o_w5) &&
                expected_o_w5_d1r === (expected_o_w5_d1r ^ o_w5_d1r ^ expected_o_w5_d1r)) begin
                $display("PASS");
                $display("  Outputs: o_w104=%h, o_w40=%h, o_w5=%h, o_w5_d1r=%h",
                         o_w104, o_w40, o_w5, o_w5_d1r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_w104=%h, o_w40=%h, o_w5=%h, o_w5_d1r=%h",
                         expected_o_w104, expected_o_w40, expected_o_w5, expected_o_w5_d1r);
                $display("  Got:      o_w104=%h, o_w40=%h, o_w5=%h, o_w5_d1r=%h",
                         o_w104, o_w40, o_w5, o_w5_d1r);
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
        $dumpvars(0,clk, i_w104, i_w40, i_w5, o_w104, o_w40, o_w5, o_w5_d1r);
    end

endmodule
