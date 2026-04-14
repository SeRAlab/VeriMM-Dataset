`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] inID_EXRt;
    reg [4:0] inIF_IDRs;
    reg [4:0] inIF_IDRt;
    reg inMemRead;
    reg inPCSrc;
    reg [4:0] inRegRtMEM;
    wire outEX_Flush;
    wire outIF_Flush;
    wire outIF_IDWrite;
    wire outPCWrite;
    wire outStall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inID_EXRt(inID_EXRt),
        .inIF_IDRs(inIF_IDRs),
        .inIF_IDRt(inIF_IDRt),
        .inMemRead(inMemRead),
        .inPCSrc(inPCSrc),
        .inRegRtMEM(inRegRtMEM),
        .outEX_Flush(outEX_Flush),
        .outIF_Flush(outIF_Flush),
        .outIF_IDWrite(outIF_IDWrite),
        .outPCWrite(outPCWrite),
        .outStall(outStall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal Operation (No Hazards)", test_num);
            inPCSrc = 0;
            inMemRead = 0;
            inID_EXRt = 5'd10;
            inIF_IDRs = 5'd1;
            inIF_IDRt = 5'd2;
            inRegRtMEM = 5'd0;

            #1;


            check_outputs(0, 0, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load-Use Hazard (Rs Dependency)", test_num);
            inPCSrc = 0;
            inMemRead = 1;
            inID_EXRt = 5'd10;
            inIF_IDRs = 5'd10;
            inIF_IDRt = 5'd2;
            inRegRtMEM = 5'd0;

            #1;


            check_outputs(1, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load-Use Hazard (Rt Dependency)", test_num);
            inPCSrc = 0;
            inMemRead = 1;
            inID_EXRt = 5'd10;
            inIF_IDRs = 5'd1;
            inIF_IDRt = 5'd10;
            inRegRtMEM = 5'd0;

            #1;


            check_outputs(1, 0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Branch Taken", test_num);
            inPCSrc = 1;
            inMemRead = 0;
            inID_EXRt = 5'd10;
            inIF_IDRs = 5'd1;
            inIF_IDRt = 5'd2;
            inRegRtMEM = 5'd0;

            #1;


            check_outputs(1, 1, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Memory Read but No dependency", test_num);
            inPCSrc = 0;
            inMemRead = 1;
            inID_EXRt = 5'd10;
            inIF_IDRs = 5'd5;
            inIF_IDRt = 5'd6;
            inRegRtMEM = 5'd0;

            #1;


            check_outputs(0, 0, 1, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Branch Priority over Load-Use", test_num);
            inPCSrc = 1;
            inMemRead = 1;
            inID_EXRt = 5'd10;
            inIF_IDRs = 5'd10;
            inIF_IDRt = 5'd2;
            inRegRtMEM = 5'd0;

            #1;


            check_outputs(1, 1, 1, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Load-Use with Register 0", test_num);
            inPCSrc = 0;
            inMemRead = 1;
            inID_EXRt = 5'd0;
            inIF_IDRs = 5'd0;
            inIF_IDRt = 5'd2;
            inRegRtMEM = 5'd0;


            #1;



            check_outputs(1, 0, 0, 0, 1);
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
        input expected_outEX_Flush;
        input expected_outIF_Flush;
        input expected_outIF_IDWrite;
        input expected_outPCWrite;
        input expected_outStall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outEX_Flush === (expected_outEX_Flush ^ outEX_Flush ^ expected_outEX_Flush) &&
                expected_outIF_Flush === (expected_outIF_Flush ^ outIF_Flush ^ expected_outIF_Flush) &&
                expected_outIF_IDWrite === (expected_outIF_IDWrite ^ outIF_IDWrite ^ expected_outIF_IDWrite) &&
                expected_outPCWrite === (expected_outPCWrite ^ outPCWrite ^ expected_outPCWrite) &&
                expected_outStall === (expected_outStall ^ outStall ^ expected_outStall)) begin
                $display("PASS");
                $display("  Outputs: outEX_Flush=%b, outIF_Flush=%b, outIF_IDWrite=%b, outPCWrite=%b, outStall=%b",
                         outEX_Flush, outIF_Flush, outIF_IDWrite, outPCWrite, outStall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outEX_Flush=%b, outIF_Flush=%b, outIF_IDWrite=%b, outPCWrite=%b, outStall=%b",
                         expected_outEX_Flush, expected_outIF_Flush, expected_outIF_IDWrite, expected_outPCWrite, expected_outStall);
                $display("  Got:      outEX_Flush=%b, outIF_Flush=%b, outIF_IDWrite=%b, outPCWrite=%b, outStall=%b",
                         outEX_Flush, outIF_Flush, outIF_IDWrite, outPCWrite, outStall);
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
