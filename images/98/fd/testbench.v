`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EXE_MEM_HiRead;
    reg EXE_MEM_LoRead;
    reg [63:0] Hi_ReadData;
    reg [63:0] Lo_ReadData;
    reg [63:0] MEM_Result;
    reg MEM_memWrite;
    wire [63:0] MEM_Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXE_MEM_HiRead(EXE_MEM_HiRead),
        .EXE_MEM_LoRead(EXE_MEM_LoRead),
        .Hi_ReadData(Hi_ReadData),
        .Lo_ReadData(Lo_ReadData),
        .MEM_Result(MEM_Result),
        .MEM_memWrite(MEM_memWrite),
        .MEM_Data(MEM_Data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Lo_ReadData", test_num);
            EXE_MEM_LoRead = 1'b1;
            EXE_MEM_HiRead = 1'b0;
            Lo_ReadData = 64'hAAAA_BBBB_CCCC_DDDD;
            Hi_ReadData = 64'h1111_2222_3333_4444;
            MEM_Result  = 64'hFFFF_EEEE_DDDD_CCCC;
            MEM_memWrite = 1'b0;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Hi_ReadData", test_num);
            EXE_MEM_LoRead = 1'b0;
            EXE_MEM_HiRead = 1'b1;
            Lo_ReadData = 64'hAAAA_BBBB_CCCC_DDDD;
            Hi_ReadData = 64'h1111_2222_3333_4444;
            MEM_Result  = 64'hFFFF_EEEE_DDDD_CCCC;
            MEM_memWrite = 1'b0;
            #1;

            check_outputs(64'h1111_2222_3333_4444);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select MEM_Result (Neither control asserted)", test_num);
            EXE_MEM_LoRead = 1'b0;
            EXE_MEM_HiRead = 1'b0;
            Lo_ReadData = 64'hAAAA_BBBB_CCCC_DDDD;
            Hi_ReadData = 64'h1111_2222_3333_4444;
            MEM_Result  = 64'hFFFF_EEEE_DDDD_CCCC;
            MEM_memWrite = 1'b0;
            #1;

            check_outputs(64'hFFFF_EEEE_DDDD_CCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Priority Check (Both Lo and Hi asserted - Lo priority)", test_num);
            EXE_MEM_LoRead = 1'b1;
            EXE_MEM_HiRead = 1'b1;
            Lo_ReadData = 64'h5555_5555_5555_5555;
            Hi_ReadData = 64'hAAAA_AAAA_AAAA_AAAA;
            MEM_Result  = 64'h0000_0000_0000_0000;
            MEM_memWrite = 1'b0;


            #1;



            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs Zero, Select Result", test_num);
            EXE_MEM_LoRead = 1'b0;
            EXE_MEM_HiRead = 1'b0;
            Lo_ReadData = 64'd0;
            Hi_ReadData = 64'd0;
            MEM_Result  = 64'd0;
            MEM_memWrite = 1'b1;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs Max, Select Hi", test_num);
            EXE_MEM_LoRead = 1'b0;
            EXE_MEM_HiRead = 1'b1;
            Lo_ReadData = 64'hFFFF_FFFF_FFFF_FFFF;
            Hi_ReadData = 64'hFFFF_FFFF_FFFF_FFFF;
            MEM_Result  = 64'hFFFF_FFFF_FFFF_FFFF;
            MEM_memWrite = 1'b0;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Data Check", test_num);
            EXE_MEM_LoRead = 1'b0;
            EXE_MEM_HiRead = 1'b0;
            Lo_ReadData = 64'h1234_5678_9ABC_DEF0;
            Hi_ReadData = 64'hFEDC_BA98_7654_3210;
            MEM_Result  = 64'h8888_7777_6666_5555;
            MEM_memWrite = 1'b1;
            #1;

            check_outputs(64'h8888_7777_6666_5555);
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
        input [63:0] expected_MEM_Data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MEM_Data === (expected_MEM_Data ^ MEM_Data ^ expected_MEM_Data)) begin
                $display("PASS");
                $display("  Outputs: MEM_Data=%h",
                         MEM_Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MEM_Data=%h",
                         expected_MEM_Data);
                $display("  Got:      MEM_Data=%h",
                         MEM_Data);
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
