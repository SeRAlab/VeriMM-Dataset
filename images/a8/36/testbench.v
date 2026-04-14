`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg IF_ID_Write;
    reg [31:0] IMin;
    reg PCSrc;
    reg Rst;
    reg [31:0] addIn;
    wire [31:0] IMout;
    wire [31:0] addOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .IF_ID_Write(IF_ID_Write),
        .IMin(IMin),
        .PCSrc(PCSrc),
        .Rst(Rst),
        .addIn(addIn),
        .IMout(IMout),
        .addOut(addOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            IF_ID_Write = 0;
            PCSrc = 0;
            IMin = 32'h0;
            addIn = 32'h0;
            @(posedge Clk);
            #1;
            Rst = 0;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Write Operation", test_num);
            reset_dut();


            IMin = 32'hABCD_1234;
            addIn = 32'h0000_1000;
            IF_ID_Write = 1;
            PCSrc = 0;

            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'hABCD_1234, 32'h0000_1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Disable (IF_ID_Write=0)", test_num);
            reset_dut();


            IMin = 32'h1111_1111;
            addIn = 32'h0000_0004;
            IF_ID_Write = 1;
            PCSrc = 0;
            @(posedge Clk);
            #2;


            IMin = 32'hEEEE_EEEE;
            addIn = 32'hFFFF_FFFF;
            IF_ID_Write = 0;
            PCSrc = 0;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(32'h1111_1111, 32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Blocked by PCSrc=1", test_num);
            reset_dut();


            IMin = 32'h2222_2222;
            addIn = 32'h0000_0008;
            IF_ID_Write = 1;
            PCSrc = 0;
            @(posedge Clk);
            #2;


            IMin = 32'hDEAD_BEEF;
            addIn = 32'h0000_000C;
            IF_ID_Write = 1;
            PCSrc = 1;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(32'h2222_2222, 32'h0000_0008);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Combined Stall and PCSrc Condition", test_num);
            reset_dut();


            IMin = 32'h3333_3333;
            addIn = 32'h0000_0010;
            IF_ID_Write = 1;
            PCSrc = 0;
            @(posedge Clk);
            #2;


            IMin = 32'hCAFE_BABE;
            addIn = 32'h0000_0020;
            IF_ID_Write = 0;
            PCSrc = 1;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(32'h3333_3333, 32'h0000_0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Post-Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Back-to-back Writes", test_num);
            reset_dut();


            IMin = 32'h1; addIn = 32'hA; IF_ID_Write = 1; PCSrc = 0;
            @(posedge Clk);
            #1;


            IMin = 32'h2; addIn = 32'hB; IF_ID_Write = 1; PCSrc = 0;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h2, 32'hB);
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
        input [31:0] expected_IMout;
        input [31:0] expected_addOut;
        begin
            if (expected_IMout === (expected_IMout ^ IMout ^ expected_IMout) &&
                expected_addOut === (expected_addOut ^ addOut ^ expected_addOut)) begin
                $display("PASS");
                $display("  Outputs: IMout=%h, addOut=%h",
                         IMout, addOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IMout=%h, addOut=%h",
                         expected_IMout, expected_addOut);
                $display("  Got:      IMout=%h, addOut=%h",
                         IMout, addOut);
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
        $dumpvars(0,Clk, IF_ID_Write, IMin, PCSrc, Rst, addIn, IMout, addOut);
    end

endmodule
