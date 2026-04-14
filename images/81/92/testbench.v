`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLOCK;
    reg iCONF_ENA;
    reg iCONF_WRITE;
    reg [63:0] iCOUNT_COUNTER;
    reg iCOUNT_WRITE;
    reg [1:0] inCOUNT_DQM;
    reg inRESET;
    wire [63:0] oCOUNTER;
    wire oWORKING;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLOCK(iCLOCK),
        .iCONF_ENA(iCONF_ENA),
        .iCONF_WRITE(iCONF_WRITE),
        .iCOUNT_COUNTER(iCOUNT_COUNTER),
        .iCOUNT_WRITE(iCOUNT_WRITE),
        .inCOUNT_DQM(inCOUNT_DQM),
        .inRESET(inRESET),
        .oCOUNTER(oCOUNTER),
        .oWORKING(oWORKING)
    );

    // Clock generation (10ns period)
    initial begin
        iCLOCK = 0;
        forever #5 iCLOCK = ~iCLOCK;
    end

        task reset_dut;

        begin
            inRESET = 1'b0;
            iCONF_ENA = 1'b0;
            iCONF_WRITE = 1'b0;
            iCOUNT_COUNTER = 64'h0;
            iCOUNT_WRITE = 1'b0;
            inCOUNT_DQM = 2'b11;
            @(posedge iCLOCK);
            #1 inRESET = 1'b1;
            @(posedge iCLOCK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Counter and Incrementing", test_num);
            reset_dut();


            iCONF_ENA = 1'b1;
            iCONF_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCONF_WRITE = 1'b0;


            repeat(10) @(posedge iCLOCK);


            #1 #1;
 check_outputs(64'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full 64-bit Counter Write", test_num);
            reset_dut();



            iCOUNT_COUNTER = 64'hAAAABBBBCCCCDDDD;
            inCOUNT_DQM = 2'b00;
            iCOUNT_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCOUNT_WRITE = 1'b0;


            #1;



            check_outputs(64'hAAAABBBBCCCCDDDD, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Partial Write using DQM", test_num);
            reset_dut();


            iCOUNT_COUNTER = 64'h1111222233334444;
            inCOUNT_DQM = 2'b00;
            iCOUNT_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCOUNT_WRITE = 1'b0;




            iCOUNT_COUNTER = 64'hFFFFFFFF_00000000;
            inCOUNT_DQM = 2'b01;
            iCOUNT_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCOUNT_WRITE = 1'b0;


            #1;



            check_outputs(64'hFFFFFFFF33334444, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stop Counter Operation", test_num);
            reset_dut();


            iCONF_ENA = 1'b1;
            iCONF_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCONF_WRITE = 1'b0;

            repeat(5) @(posedge iCLOCK);


            iCONF_ENA = 1'b0;
            iCONF_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCONF_WRITE = 1'b0;

            repeat(5) @(posedge iCLOCK);




            #1;





            check_outputs(64'd6, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Overflow (Wrap-around)", test_num);
            reset_dut();


            iCOUNT_COUNTER = 64'hFFFFFFFFFFFFFFFE;
            inCOUNT_DQM = 2'b00;
            iCOUNT_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCOUNT_WRITE = 1'b0;


            iCONF_ENA = 1'b1;
            iCONF_WRITE = 1'b1;
            @(posedge iCLOCK);
            #1 iCONF_WRITE = 1'b0;

            repeat(3) @(posedge iCLOCK);


            #1;



            check_outputs(64'h0000000000000001, 1'b1);
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
        input [63:0] expected_oCOUNTER;
        input expected_oWORKING;
        begin
            if (expected_oCOUNTER === (expected_oCOUNTER ^ oCOUNTER ^ expected_oCOUNTER) &&
                expected_oWORKING === (expected_oWORKING ^ oWORKING ^ expected_oWORKING)) begin
                $display("PASS");
                $display("  Outputs: oCOUNTER=%h, oWORKING=%b",
                         oCOUNTER, oWORKING);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCOUNTER=%h, oWORKING=%b",
                         expected_oCOUNTER, expected_oWORKING);
                $display("  Got:      oCOUNTER=%h, oWORKING=%b",
                         oCOUNTER, oWORKING);
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
        $dumpvars(0,iCLOCK, iCONF_ENA, iCONF_WRITE, iCOUNT_COUNTER, iCOUNT_WRITE, inCOUNT_DQM, inRESET, oCOUNTER, oWORKING);
    end

endmodule
