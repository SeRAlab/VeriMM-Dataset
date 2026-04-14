`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] iAddr;
    reg iCLK;
    reg [15:0] iData;
    reg iWen;
    wire [15:0] oData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iAddr(iAddr),
        .iCLK(iCLK),
        .iData(iData),
        .iWen(iWen),
        .oData(oData)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iWen = 0;
            iAddr = 0;
            iData = 0;
            @(posedge iCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);


            iAddr = 8'h01;
            iData = 16'hABCD;
            iWen = 1;
            @(posedge iCLK);


            #1 iWen = 0;
            @(posedge iCLK);

            #1 #1;
 check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Boundary Address 0xFF Write/Read", test_num);


            iAddr = 8'hFF;
            iData = 16'h55AA;
            iWen = 1;
            @(posedge iCLK);


            #1 iWen = 0;
            @(posedge iCLK);

            #1 #1;
 check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Overwrite Check", test_num);


            iAddr = 8'h10;
            iData = 16'h1111;
            iWen = 1;
            @(posedge iCLK);


            #1 iData = 16'h2222;
            @(posedge iCLK);


            #1 iWen = 0;
            @(posedge iCLK);

            #1 #1;
 check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Write Enable (iWen) Check", test_num);


            iAddr = 8'h20;
            iData = 16'h7777;
            iWen = 1;
            @(posedge iCLK);


            #1 iWen = 0;
            iData = 16'h8888;
            @(posedge iCLK);


            @(posedge iCLK);

            #1 #1;
 check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Address Independence Check", test_num);


            iAddr = 8'h05;
            iData = 16'hAAAA;
            iWen = 1;
            @(posedge iCLK);


            #1 iAddr = 8'h06;
            iData = 16'hBBBB;
            @(posedge iCLK);


            #1 iWen = 0;
            iAddr = 8'h05;
            @(posedge iCLK);

            #1 #1;
 check_outputs(16'hAAAA);
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
        input [15:0] expected_oData;
        begin
            if (expected_oData === (expected_oData ^ oData ^ expected_oData)) begin
                $display("PASS");
                $display("  Outputs: oData=%h",
                         oData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oData=%h",
                         expected_oData);
                $display("  Got:      oData=%h",
                         oData);
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
        $dumpvars(0,iAddr, iCLK, iData, iWen, oData);
    end

endmodule
