`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dataIn;
    reg wrtEn;
    wire [31:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn(dataIn),
        .wrtEn(wrtEn),
        .dataOut(dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wrtEn = 1;
            dataIn = 32'h0;
            @(negedge clk);
            wrtEn = 0;
            dataIn = 32'h0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write", test_num);
            reset_dut();

            wrtEn = 1;
            dataIn = 32'hDEADBEEF;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Enable Low", test_num);
            reset_dut();

            wrtEn = 0;
            dataIn = 32'h12345678;
            @(negedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Persistence", test_num);
            reset_dut();


            wrtEn = 1;
            dataIn = 32'hAAAA5555;
            @(negedge clk);


            wrtEn = 0;
            dataIn = 32'hFFFFFFFF;
            repeat(3) @(negedge clk);

            #2;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Falling Edge Sensitivity", test_num);
            reset_dut();

            wrtEn = 1;
            dataIn = 32'h77778888;

            @(posedge clk);
            #1;
            if (dataOut === 32'h77778888) begin
                $display("FAIL: Data updated on rising edge instead of falling edge");
            end

            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h77778888);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Write", test_num);
            reset_dut();

            wrtEn = 1;
            dataIn = 32'hFFFFFFFF;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_dataOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h",
                         expected_dataOut);
                $display("  Got:      dataOut=%h",
                         dataOut);
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
        $dumpvars(0,clk, dataIn, wrtEn, dataOut);
    end

endmodule
