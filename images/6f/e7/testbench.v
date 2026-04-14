`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] datain;
    reg enable;
    reg rst_n;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .enable(enable),
        .rst_n(rst_n),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            datain = 0;
            enable = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 0;
            datain = 32'd15000000;
            @(posedge clk); #1;
            #1;

            check_outputs(32'd15000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 0;
            datain = -32'd15000000;
            @(posedge clk); #1;
            #1;

            check_outputs(-32'd15000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            datain = 32'd5000;
            @(posedge clk); #1;
            #1;

            check_outputs(32'd5000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            datain = -32'd5000;
            @(posedge clk); #1;
            #1;

            check_outputs(-32'd5000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 1;
            datain = 32'd20000000;
            @(posedge clk); #1;
            #1;

            check_outputs(MAX_LIMIT);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 1;
            datain = -32'd20000000;
            @(posedge clk); #1;
            #1;

            check_outputs(MIN_LIMIT);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            enable = 1;
            datain = MAX_LIMIT;
            @(posedge clk); #1;
            #1;

            check_outputs(MAX_LIMIT);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            enable = 1;
            datain = MIN_LIMIT;
            @(posedge clk); #1;
            #1;

            check_outputs(MIN_LIMIT);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            enable = 1;
            datain = 32'd10240001;
            @(posedge clk); #1;

            if (dataout !== MAX_LIMIT) $display("Intermediate fail in 010");

            enable = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(32'd10240001);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_dataout;
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
        $dumpvars(0,clk, datain, enable, rst_n, dataout);
    end

endmodule
