`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] xin;
    reg [15:0] yin;
    reg [15:0] zin;
    wire [15:0] xout;
    wire [15:0] yout;
    wire [15:0] zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .xin(xin),
        .yin(yin),
        .zin(zin),
        .xout(xout),
        .yout(yout),
        .zout(zout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            xin = 16'h0;
            yin = 16'h0;
            zin = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Delay Test", test_num);
            reset_dut();


            xin = 16'hABCD;
            yin = 16'h1234;
            zin = 16'h55AA;


            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hABCD, 16'h1234, 16'h55AA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros Test", test_num);
            reset_dut();


            xin = 16'h0000;
            yin = 16'h0000;
            zin = 16'h0000;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Values Test", test_num);
            reset_dut();


            xin = 16'hFFFF;
            yin = 16'hFFFF;
            zin = 16'hFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bit Pattern", test_num);
            reset_dut();


            xin = 16'hAAAA;
            yin = 16'h5555;
            zin = 16'hF0F0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hAAAA, 16'h5555, 16'hF0F0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Update Check", test_num);
            reset_dut();


            xin = 16'h1111;
            yin = 16'h2222;
            zin = 16'h3333;
            @(posedge clk);


            xin = 16'h4444;
            yin = 16'h5555;
            zin = 16'h6666;
            @(posedge clk);
            #2;



            #1;




            check_outputs(16'h4444, 16'h5555, 16'h6666);
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
        input [15:0] expected_xout;
        input [15:0] expected_yout;
        input [15:0] expected_zout;
        begin
            if (expected_xout === (expected_xout ^ xout ^ expected_xout) &&
                expected_yout === (expected_yout ^ yout ^ expected_yout) &&
                expected_zout === (expected_zout ^ zout ^ expected_zout)) begin
                $display("PASS");
                $display("  Outputs: xout=%h, yout=%h, zout=%h",
                         xout, yout, zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xout=%h, yout=%h, zout=%h",
                         expected_xout, expected_yout, expected_zout);
                $display("  Got:      xout=%h, yout=%h, zout=%h",
                         xout, yout, zout);
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
        $dumpvars(0,clk, xin, yin, zin, xout, yout, zout);
    end

endmodule
