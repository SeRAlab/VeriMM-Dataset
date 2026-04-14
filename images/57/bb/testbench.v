`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DAddr;
    reg [31:0] DataIn;
    reg RD;
    reg WR;
    wire [31:0] DataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DAddr(DAddr),
        .DataIn(DataIn),
        .RD(RD),
        .WR(WR),
        .DataOut(DataOut)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            DAddr = 32'h0;
            DataIn = 32'h0;
            RD = 0;
            WR = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read at Address 0", test_num);
            reset_dut();


            @(posedge CLK);
            DAddr = 32'h0;
            DataIn = 32'h12345678;
            WR = 1;
            RD = 0;
            @(negedge CLK);


            WR = 0;
            RD = 1;
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address (124)", test_num);
            reset_dut();


            @(posedge CLK);
            DAddr = 32'd124;
            DataIn = 32'hABCDEFFF;
            WR = 1;
            @(negedge CLK);

            WR = 0;
            RD = 1;
            #2;
            #1;

            check_outputs(32'hABCDEFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite existing data", test_num);
            reset_dut();


            @(posedge CLK);
            DAddr = 32'h10;
            DataIn = 32'hAAAA_AAAA;
            WR = 1;
            @(negedge CLK);


            @(posedge CLK);
            DataIn = 32'h5555_5555;
            @(negedge CLK);

            WR = 0;
            RD = 1;
            #2;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Writes and Sequential Reads", test_num);
            reset_dut();


            @(posedge CLK);
            DAddr = 32'd20; DataIn = 32'h11111111; WR = 1;
            @(negedge CLK);


            @(posedge CLK);
            DAddr = 32'd40; DataIn = 32'h22222222;
            @(negedge CLK);


            WR = 0;
            RD = 1;
            DAddr = 32'd20;
            #2;


            DAddr = 32'd40;
            #2;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: WR signal validation", test_num);
            reset_dut();


            @(posedge CLK);
            DAddr = 32'h30;
            DataIn = 32'hCAFECAFE;
            WR = 0;
            @(negedge CLK);


            RD = 1;
            #2;
            if (DataOut === 32'hCAFECAFE) begin
                $display("FAIL: Data written while WR was low");
                fail_count = fail_count + 1;
            end else begin

                #1;


                check_outputs(DataOut);
            end
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
        input [31:0] expected_DataOut;
        begin
            if (expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut)) begin
                $display("PASS");
                $display("  Outputs: DataOut=%h",
                         DataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut=%h",
                         expected_DataOut);
                $display("  Got:      DataOut=%h",
                         DataOut);
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
        $dumpvars(0,CLK, DAddr, DataIn, RD, WR, DataOut);
    end

endmodule
