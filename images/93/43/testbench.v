`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BTR_sel;
    reg LBI_sel;
    reg [15:0] PC_addr;
    reg [15:0] ReadData;
    reg [15:0] ex_result;
    reg [15:0] immed;
    reg [15:0] readData1;
    reg wb_sel;
    reg wb_sel1;
    wire [15:0] wb_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTR_sel(BTR_sel),
        .LBI_sel(LBI_sel),
        .PC_addr(PC_addr),
        .ReadData(ReadData),
        .ex_result(ex_result),
        .immed(immed),
        .readData1(readData1),
        .wb_sel(wb_sel),
        .wb_sel1(wb_sel1),
        .wb_out(wb_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Default Output (PC_addr)", test_num);

        PC_addr   = 16'h1234;
        ex_result = 16'hAAAA;
        ReadData  = 16'h5555;
        immed     = 16'hFFFF;
        readData1 = 16'h8000;

        wb_sel1   = 0;
        wb_sel    = 0;
        LBI_sel   = 0;
        BTR_sel   = 0;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select ex_result", test_num);

        PC_addr   = 16'h1234;
        ex_result = 16'hABCD;
        ReadData  = 16'h5555;
        immed     = 16'hFFFF;
        readData1 = 16'h8000;

        wb_sel    = 0;
        wb_sel1   = 1;
        LBI_sel   = 0;
        BTR_sel   = 0;

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select ReadData", test_num);

        PC_addr   = 16'h1234;
        ex_result = 16'hAAAA;
        ReadData  = 16'h7777;
        immed     = 16'hFFFF;
        readData1 = 16'h8000;

        wb_sel    = 1;
        wb_sel1   = 0;
        LBI_sel   = 0;
        BTR_sel   = 0;

        #1;


        check_outputs(16'h7777);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select Immediate (LBI)", test_num);

        PC_addr   = 16'h1234;
        ex_result = 16'hAAAA;
        ReadData  = 16'h5555;
        immed     = 16'h4321;
        readData1 = 16'h8000;

        wb_sel    = 0;
        wb_sel1   = 0;
        LBI_sel   = 1;
        BTR_sel   = 0;

        #1;


        check_outputs(16'h4321);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Select Bit-Reversed readData1 (BTR)", test_num);

        PC_addr   = 16'h1234;
        ex_result = 16'hAAAA;
        ReadData  = 16'h5555;
        immed     = 16'hFFFF;


        readData1 = 16'h1234;

        wb_sel    = 0;
        wb_sel1   = 0;
        LBI_sel   = 0;
        BTR_sel   = 1;

        #1;


        check_outputs(16'h2C48);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Priority Check (BTR over LBI and Main Mux)", test_num);

        PC_addr   = 16'h1111;
        ex_result = 16'h2222;
        ReadData  = 16'h3333;
        immed     = 16'h4444;

        readData1 = 16'hFFFF;

        wb_sel    = 1;
        wb_sel1   = 1;
        LBI_sel   = 1;
        BTR_sel   = 1;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Priority Check (LBI over Main Mux)", test_num);

        PC_addr   = 16'h1111;
        ex_result = 16'h2222;
        ReadData  = 16'h3333;
        immed     = 16'hBEEF;
        readData1 = 16'h0000;

        wb_sel    = 1;
        wb_sel1   = 1;
        LBI_sel   = 1;
        BTR_sel   = 0;

        #1;


        check_outputs(16'hBEEF);
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
        input [15:0] expected_wb_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wb_out === (expected_wb_out ^ wb_out ^ expected_wb_out)) begin
                $display("PASS");
                $display("  Outputs: wb_out=%h",
                         wb_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_out=%h",
                         expected_wb_out);
                $display("  Got:      wb_out=%h",
                         wb_out);
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

endmodule
