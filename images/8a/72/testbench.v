`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Addr;
    reg [7:0] Axis;
    reg [7:0] Din;
    reg PClk;
    reg [15:0] PlsCnt;
    reg PosLock;
    wire [7:0] DQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .Axis(Axis),
        .Din(Din),
        .PClk(PClk),
        .PlsCnt(PlsCnt),
        .PosLock(PosLock),
        .DQ(DQ)
    );

    // Clock generation (10ns period)
    initial begin
        PosLock = 0;
        forever #5 PosLock = ~PosLock;
    end

        task reset_dut;

        begin
            Addr = 8'h0;
            Axis = 8'h0;
            Din = 8'h0;
            PClk = 0;
            PlsCnt = 16'h0;

            @(posedge PosLock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reading TxPlsCnt Low Byte (Addr[1:0]=00)", test_num);
            reset_dut();

            PlsCnt = 16'hA53C;
            @(posedge PosLock);
            #2;
            Addr = 8'b0000_0000;

            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reading TxPlsCnt High Byte (Addr[1:0]=01)", test_num);
            reset_dut();

            PlsCnt = 16'hBD24;
            @(posedge PosLock);
            #2;
            Addr = 8'b0000_0001;

            #1;
            #1;

            check_outputs(8'hBD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reading Axis value (Addr[1]=1)", test_num);
            reset_dut();

            Axis = 8'h7E;
            Addr = 8'b0000_0010;

            #1;
            #1;

            check_outputs(8'h7E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify PosLock capture stability", test_num);
            reset_dut();


            PlsCnt = 16'h1122;
            @(posedge PosLock);
            #2;


            PlsCnt = 16'h9999;
            Addr = 8'b0000_0000;

            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Addr[1] priority", test_num);
            reset_dut();

            PlsCnt = 16'h1234;
            Axis = 8'hFF;
            @(posedge PosLock);
            #2;

            Addr = 8'b0000_0011;

            #1;

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_DQ;
        begin
            if (expected_DQ === (expected_DQ ^ DQ ^ expected_DQ)) begin
                $display("PASS");
                $display("  Outputs: DQ=%h",
                         DQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DQ=%h",
                         expected_DQ);
                $display("  Got:      DQ=%h",
                         DQ);
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
        $dumpvars(0,Addr, Axis, Din, PClk, PlsCnt, PosLock, DQ);
    end

endmodule
