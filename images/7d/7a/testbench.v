`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] inData;
    reg rdEn;
    reg wrEn;
    wire [15:0] outData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inData(inData),
        .rdEn(rdEn),
        .wrEn(wrEn),
        .outData(outData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wrEn = 0;
            rdEn = 0;
            inData = 16'h0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            inData = 16'hAAAA;
            wrEn = 1;
            @(posedge clk);
            wrEn = 0;


            rdEn = 1;
            @(posedge clk);
            rdEn = 0;

            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            wrEn = 1;
            inData = 16'h0001; @(posedge clk);
            inData = 16'h0002; @(posedge clk);
            inData = 16'h0003; @(posedge clk);
            inData = 16'h0004; @(posedge clk);
            wrEn = 0;


            rdEn = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            rdEn = 0;

            #1;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            wrEn = 1;
            inData = 16'h1111; @(posedge clk);
            inData = 16'h2222; @(posedge clk);
            inData = 16'h3333; @(posedge clk);
            inData = 16'h4444; @(posedge clk);
            wrEn = 0;


            rdEn = 1;
            repeat(4) @(posedge clk);
            rdEn = 0;


            wrEn = 1;
            inData = 16'h5555;
            @(posedge clk);
            wrEn = 0;


            rdEn = 1;
            @(posedge clk);
            rdEn = 0;

            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            inData = 16'hCCCC;
            wrEn = 1;
            @(posedge clk);


            inData = 16'hDDDD;
            wrEn = 1;
            rdEn = 1;
            @(posedge clk);

            wrEn = 0;
            rdEn = 0;

            #1;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            wrEn = 1;
            inData = 16'h000A; @(posedge clk);
            inData = 16'h000B; @(posedge clk);
            inData = 16'h000C; @(posedge clk);
            inData = 16'h000D; @(posedge clk);
            inData = 16'h000E; @(posedge clk);
            inData = 16'h000F; @(posedge clk);
            wrEn = 0;


            rdEn = 1;
            @(posedge clk);
            @(posedge clk);
            rdEn = 0;

            #1;
            #1;

            check_outputs(16'h000F);
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
        input [15:0] expected_outData;
        begin
            if (expected_outData === (expected_outData ^ outData ^ expected_outData)) begin
                $display("PASS");
                $display("  Outputs: outData=%h",
                         outData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outData=%h",
                         expected_outData);
                $display("  Got:      outData=%h",
                         outData);
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
        $dumpvars(0,clk, inData, rdEn, wrEn, outData);
    end

endmodule
