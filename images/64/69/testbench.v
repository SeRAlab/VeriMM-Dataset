`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [20:0] datain;
    reg we;
    wire [20:0] dataout;

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
            @(posedge clk);
            we <= 1;
            datain <= 21'h0;
            @(posedge clk);
            datain <= 21'h0;
            @(posedge clk);
            we <= 0;
            datain <= 21'h0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            @(posedge clk);
            we <= 1;
            datain <= 21'h12345;
            @(posedge clk);
            we <= 1;
            datain <= 21'h6789A;
            @(posedge clk);
            we <= 0;
            #1;

            check_outputs(21'h12345);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge clk);
            we <= 1;
            datain <= 21'hAAAAA;
            @(posedge clk);
            we <= 1;
            datain <= 21'hBBBBB;
            @(posedge clk);
            we <= 0;
            datain <= 21'hFFFFF;
            @(posedge clk);
            #1;

            check_outputs(21'hAAAAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(posedge clk);
            we <= 1;
            datain <= 21'h1FFFFF;
            @(posedge clk);
            we <= 1;
            datain <= 21'h000000;
            @(posedge clk);
            we <= 0;
            #1;

            check_outputs(21'h1FFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge clk);
            we <= 1;
            datain <= 21'h11111;
            @(posedge clk);
            we <= 0;
            datain <= 21'h22222;
            @(posedge clk);
            we <= 0;
            datain <= 21'h33333;
            @(posedge clk);
            we <= 1;
            datain <= 21'h44444;
            @(posedge clk);
            we <= 0;
            #1;

            check_outputs(21'h11111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(posedge clk);
            we <= 1; datain <= 21'h00001;
            @(posedge clk);
            we <= 1; datain <= 21'h00002;
            @(posedge clk);
            we <= 1; datain <= 21'h00003;
            @(posedge clk);
            we <= 1; datain <= 21'h00004;
            @(posedge clk);
            we <= 0;
            #1;

            check_outputs(21'h00003);
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
        input [20:0] expected_dataout;
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
