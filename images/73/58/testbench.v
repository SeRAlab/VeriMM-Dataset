`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] a;
    reg ce;
    reg clk;
    reg [7:0] din;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce(ce),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
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
            a = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            ce = 1; we = 1; a = 10'h1FF; din = 8'hA5;
            @(negedge clk);


            we = 0; a = 10'h1FF;
            @(negedge clk);


            #1;



            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Boundary Check Max Address", test_num);
            reset_dut();


            @(negedge clk);
            ce = 1; we = 1; a = 10'h3FF; din = 8'hFF;
            @(negedge clk);


            we = 0; a = 10'h3FF;
            @(negedge clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Chip Enable Validation", test_num);
            reset_dut();


            @(negedge clk);
            ce = 1; we = 1; a = 10'h005; din = 8'h11;
            @(negedge clk);


            ce = 0; we = 1; a = 10'h005; din = 8'h22;
            @(negedge clk);


            ce = 1; we = 0; a = 10'h005;
            @(negedge clk);


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Validation", test_num);
            reset_dut();


            @(negedge clk);
            ce = 1; we = 1; a = 10'h00A; din = 8'h55;
            @(negedge clk);


            ce = 1; we = 0; a = 10'h00A; din = 8'h66;
            @(negedge clk);


            ce = 1; we = 0; a = 10'h00A;
            @(negedge clk);


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            @(negedge clk);
            ce = 1; we = 1; a = 10'h020; din = 8'hAA;
            @(negedge clk);


            ce = 1; we = 1; a = 10'h020; din = 8'hBB;
            @(negedge clk);


            we = 0; a = 10'h020;
            @(negedge clk);

            #1;


            check_outputs(8'hBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multi-address Persistence", test_num);
            reset_dut();


            @(negedge clk);
            ce = 1; we = 1; a = 10'h100; din = 8'h12;
            @(negedge clk);


            ce = 1; we = 1; a = 10'h101; din = 8'h34;
            @(negedge clk);


            we = 0; a = 10'h100;
            @(negedge clk);

            #1;


            check_outputs(8'h12);
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,a, ce, clk, din, we, dout);
    end

endmodule
