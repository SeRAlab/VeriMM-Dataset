`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ENET_INT;
    reg iCLK;
    reg iCMD;
    reg iCS_N;
    reg [15:0] iDATA;
    reg iOSC_50;
    reg iRD_N;
    reg iRST_N;
    reg iWR_N;
    wire ENET_CLK;
    wire ENET_CMD;
    wire ENET_CS_N;
    wire ENET_RD_N;
    wire ENET_RST_N;
    wire ENET_WR_N;
    wire [15:0] oDATA;
    wire oINT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENET_INT(ENET_INT),
        .iCLK(iCLK),
        .iCMD(iCMD),
        .iCS_N(iCS_N),
        .iDATA(iDATA),
        .iOSC_50(iOSC_50),
        .iRD_N(iRD_N),
        .iRST_N(iRST_N),
        .iWR_N(iWR_N),
        .ENET_CLK(ENET_CLK),
        .ENET_CMD(ENET_CMD),
        .ENET_CS_N(ENET_CS_N),
        .ENET_RD_N(ENET_RD_N),
        .ENET_RST_N(ENET_RST_N),
        .ENET_WR_N(ENET_WR_N),
        .oDATA(oDATA),
        .oINT(oINT)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST_N = 1'b0;
            iCS_N = 1'b1;
            iRD_N = 1'b1;
            iWR_N = 1'b1;
            iCMD = 1'b0;
            iDATA = 16'h0000;
            ENET_INT = 1'b0;
            enet_data_drive_en = 1'b0;
            enet_data_drive_reg = 16'h0000;
            repeat (5) @(posedge iCLK);
            iRST_N = 1'b1;
            repeat (2) @(posedge iCLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Post-Reset Idle State", test_num);


            #1;



            check_outputs(iOSC_50, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Command Mapping", test_num);

            @(posedge iCLK);
            iCS_N = 1'b0;
            iWR_N = 1'b0;
            iCMD  = 1'b1;
            iDATA = 16'hAAAA;

            @(posedge iCLK);


            #1;



            check_outputs(iOSC_50, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Read Operation", test_num);

            @(posedge iCLK);
            iCS_N = 1'b0;
            iRD_N = 1'b0;
            iWR_N = 1'b1;
            iCMD  = 1'b0;


            enet_data_drive_en = 1'b1;
            enet_data_drive_reg = 16'hBEEF;

            repeat(2) @(posedge iCLK);


            #1;



            check_outputs(iOSC_50, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 16'hBEEF, 1'b0);

            enet_data_drive_en = 1'b0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupt Synchronization", test_num);

            @(posedge iCLK);
            ENET_INT = 1'b1;

            repeat(2) @(posedge iCLK);


            #1;



            check_outputs(iOSC_50, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Propagation", test_num);

            @(posedge iCLK);
            iRST_N = 1'b0;

            #1;

            #1;


            check_outputs(iOSC_50, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 16'h0000, 1'b0);
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
        input expected_ENET_CLK;
        input expected_ENET_CMD;
        input expected_ENET_CS_N;
        input expected_ENET_RD_N;
        input expected_ENET_RST_N;
        input expected_ENET_WR_N;
        input [15:0] expected_oDATA;
        input expected_oINT;
        begin
            if (expected_ENET_CLK === (expected_ENET_CLK ^ ENET_CLK ^ expected_ENET_CLK) &&
                expected_ENET_CMD === (expected_ENET_CMD ^ ENET_CMD ^ expected_ENET_CMD) &&
                expected_ENET_CS_N === (expected_ENET_CS_N ^ ENET_CS_N ^ expected_ENET_CS_N) &&
                expected_ENET_RD_N === (expected_ENET_RD_N ^ ENET_RD_N ^ expected_ENET_RD_N) &&
                expected_ENET_RST_N === (expected_ENET_RST_N ^ ENET_RST_N ^ expected_ENET_RST_N) &&
                expected_ENET_WR_N === (expected_ENET_WR_N ^ ENET_WR_N ^ expected_ENET_WR_N) &&
                expected_oDATA === (expected_oDATA ^ oDATA ^ expected_oDATA) &&
                expected_oINT === (expected_oINT ^ oINT ^ expected_oINT)) begin
                $display("PASS");
                $display("  Outputs: ENET_CLK=%b, ENET_CMD=%b, ENET_CS_N=%b, ENET_RD_N=%b, ENET_RST_N=%b, ENET_WR_N=%b, oDATA=%h, oINT=%b",
                         ENET_CLK, ENET_CMD, ENET_CS_N, ENET_RD_N, ENET_RST_N, ENET_WR_N, oDATA, oINT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENET_CLK=%b, ENET_CMD=%b, ENET_CS_N=%b, ENET_RD_N=%b, ENET_RST_N=%b, ENET_WR_N=%b, oDATA=%h, oINT=%b",
                         expected_ENET_CLK, expected_ENET_CMD, expected_ENET_CS_N, expected_ENET_RD_N, expected_ENET_RST_N, expected_ENET_WR_N, expected_oDATA, expected_oINT);
                $display("  Got:      ENET_CLK=%b, ENET_CMD=%b, ENET_CS_N=%b, ENET_RD_N=%b, ENET_RST_N=%b, ENET_WR_N=%b, oDATA=%h, oINT=%b",
                         ENET_CLK, ENET_CMD, ENET_CS_N, ENET_RD_N, ENET_RST_N, ENET_WR_N, oDATA, oINT);
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
        $dumpvars(0,ENET_INT, iCLK, iCMD, iCS_N, iDATA, iOSC_50, iRD_N, iRST_N, iWR_N, ENET_CLK, ENET_CMD, ENET_CS_N, ENET_RD_N, ENET_RST_N, ENET_WR_N, oDATA, oINT);
    end

endmodule
