`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] datain;
    reg we;
    wire [12:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .we(we),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            datain = 13'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write Operation", test_num);

            we = 1;
            datain = 13'h1ABC;
            @(posedge clk);
            #1;
            we = 0;
            datain = 13'h0000;

            #1;


            check_outputs(13'h1ABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Hold Value (WE=0)", test_num);


            we = 1;
            datain = 13'h0FFF;
            @(posedge clk);
            #1;


            we = 0;
            datain = 13'h1555;
            @(posedge clk);
            #1;

            #1;


            check_outputs(13'h0FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write All Ones", test_num);

            we = 1;
            datain = 13'h1FFF;
            @(posedge clk);
            #1;
            we = 0;

            #1;


            check_outputs(13'h1FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write All Zeros", test_num);


            we = 1;
            datain = 13'h0AAA;
            @(posedge clk);
            #1;


            datain = 13'h0000;
            @(posedge clk);
            #1;
            we = 0;

            #1;


            check_outputs(13'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Consecutive Writes", test_num);

            we = 1;
            datain = 13'h0123;
            @(posedge clk);
            #1;
            datain = 13'h0456;
            @(posedge clk);
            #1;
            datain = 13'h0789;
            @(posedge clk);
            #1;
            we = 0;

            #1;


            check_outputs(13'h0789);
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
        input [12:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,clk, datain, we, dataout);
    end

endmodule
