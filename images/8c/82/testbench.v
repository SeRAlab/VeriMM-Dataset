`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IDtoEX_MemRead;
    reg [4:0] IDtoEX_RegRt;
    reg [4:0] IFtoID_RegRs;
    reg [4:0] IFtoID_RegRt;
    reg [2:0] PCSrc;
    wire IDEX_Flush;
    wire IFDWrite;
    wire IFD_Flush;
    wire PCWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IDtoEX_MemRead(IDtoEX_MemRead),
        .IDtoEX_RegRt(IDtoEX_RegRt),
        .IFtoID_RegRs(IFtoID_RegRs),
        .IFtoID_RegRt(IFtoID_RegRt),
        .PCSrc(PCSrc),
        .IDEX_Flush(IDEX_Flush),
        .IFDWrite(IFDWrite),
        .IFD_Flush(IFD_Flush),
        .PCWrite(PCWrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal Operation (No Hazards)", test_num);

            IDtoEX_MemRead = 1'b0;
            IDtoEX_RegRt   = 5'd10;
            IFtoID_RegRs   = 5'd1;
            IFtoID_RegRt   = 5'd2;
            PCSrc          = 3'b000;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load-Use Hazard detected (Rs)", test_num);

            IDtoEX_MemRead = 1'b1;
            IDtoEX_RegRt   = 5'd15;
            IFtoID_RegRs   = 5'd15;
            IFtoID_RegRt   = 5'd2;
            PCSrc          = 3'b000;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load-Use Hazard detected (Rt)", test_num);

            IDtoEX_MemRead = 1'b1;
            IDtoEX_RegRt   = 5'd15;
            IFtoID_RegRs   = 5'd1;
            IFtoID_RegRt   = 5'd15;
            PCSrc          = 3'b000;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Branch/Jump Taken (PCSrc != 0)", test_num);

            IDtoEX_MemRead = 1'b0;
            IDtoEX_RegRt   = 5'd10;
            IFtoID_RegRs   = 5'd1;
            IFtoID_RegRt   = 5'd2;
            PCSrc          = 3'b010;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: MemRead high but no register conflict", test_num);

            IDtoEX_MemRead = 1'b1;
            IDtoEX_RegRt   = 5'd20;
            IFtoID_RegRs   = 5'd5;
            IFtoID_RegRt   = 5'd6;
            PCSrc          = 3'b000;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Load-Use and Flush Logic", test_num);



            IDtoEX_MemRead = 1'b1;
            IDtoEX_RegRt   = 5'd15;
            IFtoID_RegRs   = 5'd15;
            IFtoID_RegRt   = 5'd15;
            PCSrc          = 3'b001;




            #1;





            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
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
        input expected_IDEX_Flush;
        input expected_IFDWrite;
        input expected_IFD_Flush;
        input expected_PCWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IDEX_Flush === (expected_IDEX_Flush ^ IDEX_Flush ^ expected_IDEX_Flush) &&
                expected_IFDWrite === (expected_IFDWrite ^ IFDWrite ^ expected_IFDWrite) &&
                expected_IFD_Flush === (expected_IFD_Flush ^ IFD_Flush ^ expected_IFD_Flush) &&
                expected_PCWrite === (expected_PCWrite ^ PCWrite ^ expected_PCWrite)) begin
                $display("PASS");
                $display("  Outputs: IDEX_Flush=%b, IFDWrite=%b, IFD_Flush=%b, PCWrite=%b",
                         IDEX_Flush, IFDWrite, IFD_Flush, PCWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IDEX_Flush=%b, IFDWrite=%b, IFD_Flush=%b, PCWrite=%b",
                         expected_IDEX_Flush, expected_IFDWrite, expected_IFD_Flush, expected_PCWrite);
                $display("  Got:      IDEX_Flush=%b, IFDWrite=%b, IFD_Flush=%b, PCWrite=%b",
                         IDEX_Flush, IFDWrite, IFD_Flush, PCWrite);
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
