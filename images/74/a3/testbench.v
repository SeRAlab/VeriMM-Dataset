`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg [31:0] In;
    reg Reset_1;
    reg enb_1_2000_0;
    reg reset;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .In(In),
        .Reset_1(Reset_1),
        .enb_1_2000_0(enb_1_2000_0),
        .reset(reset),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            reset = 1;
            Reset_1 = 0;
            enb_1_2000_0 = 0;
            In = 0;
            @(posedge CLK_IN);
            #1;
            reset = 0;
            @(posedge CLK_IN);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset_1 priority check", test_num);
            reset_dut();


            Reset_1 = 1;
            In = 32'hA5A5A5A5;
            enb_1_2000_0 = 1;
            @(posedge CLK_IN);
            #1;


            #1;



            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data propagation (enb=1, Reset_1=0)", test_num);
            reset_dut();

            Reset_1 = 0;
            enb_1_2000_0 = 1;
            In = 32'h12345678;
            @(posedge CLK_IN);
            #1;


            #1;



            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data hold (enb=0)", test_num);
            reset_dut();


            Reset_1 = 0;
            enb_1_2000_0 = 1;
            In = 32'hDEADBEEF;
            @(posedge CLK_IN);
            #1;


            enb_1_2000_0 = 0;
            In = 32'h0000FFFF;
            @(posedge CLK_IN);
            #1;


            #1;



            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Internal reset signal check", test_num);
            reset_dut();


            Reset_1 = 0;
            enb_1_2000_0 = 1;
            In = 32'hFFFFFFFF;
            @(posedge CLK_IN);
            #1;


            reset = 1;
            @(posedge CLK_IN);
            #1;


            #1;



            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset_1 deassertion transition", test_num);
            reset_dut();


            Reset_1 = 1;
            enb_1_2000_0 = 1;
            In = 32'hCAFEBABE;
            @(posedge CLK_IN);
            #1;


            Reset_1 = 0;
            #1;

            #1;


            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,CLK_IN, In, Reset_1, enb_1_2000_0, reset, Out);
    end

endmodule
