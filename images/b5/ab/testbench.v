`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BITVAL;
    reg CLK;
    reg ENA;
    reg RST;
    wire [6:0] CRC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BITVAL(BITVAL),
        .CLK(CLK),
        .ENA(ENA),
        .RST(RST),
        .CRC(CRC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            ENA = 0;
            BITVAL = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit '1'", test_num);
            reset_dut();
            @(posedge CLK);
            ENA = 1; BITVAL = 1;
            @(posedge CLK);
            ENA = 0;
            #1;

            check_outputs(7'h09);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit '0'", test_num);
            reset_dut();
            @(posedge CLK);
            ENA = 1; BITVAL = 0;
            @(posedge CLK);
            ENA = 0;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequence '101'", test_num);
            reset_dut();
            @(posedge CLK);
            ENA = 1; BITVAL = 1;
            @(posedge CLK);
            BITVAL = 0;
            @(posedge CLK);
            BITVAL = 1;
            @(posedge CLK);
            ENA = 0;
            #1;

            check_outputs(7'h2D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequence '10110'", test_num);
            reset_dut();
            @(posedge CLK);
            ENA = 1; BITVAL = 1;
            @(posedge CLK);
            BITVAL = 0;
            @(posedge CLK);
            BITVAL = 1;
            @(posedge CLK);
            BITVAL = 1;
            @(posedge CLK);
            BITVAL = 0;
            @(posedge CLK);
            ENA = 0;
            #1;

            check_outputs(7'h2F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal toggle check", test_num);
            reset_dut();
            @(posedge CLK);
            ENA = 1; BITVAL = 1;
            @(posedge CLK);
            BITVAL = 0;
            @(posedge CLK);
            ENA = 0; BITVAL = 1;
            @(posedge CLK);
            @(posedge CLK);
            ENA = 1; BITVAL = 1;
            @(posedge CLK);
            ENA = 0;
            #1;

            check_outputs(7'h2D);
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
        input [6:0] expected_CRC;
        begin
            if (expected_CRC === (expected_CRC ^ CRC ^ expected_CRC)) begin
                $display("PASS");
                $display("  Outputs: CRC=%h",
                         CRC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CRC=%h",
                         expected_CRC);
                $display("  Got:      CRC=%h",
                         CRC);
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
        $dumpvars(0,BITVAL, CLK, ENA, RST, CRC);
    end

endmodule
