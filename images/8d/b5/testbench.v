`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Dev1_Irq;
    reg [31:0] Dev1_RD;
    reg Dev2_Irq;
    reg [31:0] Dev2_RD;
    reg [29:0] PrAddr;
    reg [3:0] PrBe;
    reg [31:0] PrWD;
    wire Dev1_WE;
    wire Dev2_WE;
    wire [1:0] DevAddr;
    wire [31:0] DevWd;
    wire [5:0] HWInt;
    wire [31:0] PrRD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Dev1_Irq(Dev1_Irq),
        .Dev1_RD(Dev1_RD),
        .Dev2_Irq(Dev2_Irq),
        .Dev2_RD(Dev2_RD),
        .PrAddr(PrAddr),
        .PrBe(PrBe),
        .PrWD(PrWD),
        .Dev1_WE(Dev1_WE),
        .Dev2_WE(Dev2_WE),
        .DevAddr(DevAddr),
        .DevWd(DevWd),
        .HWInt(HWInt),
        .PrRD(PrRD)
    );
    task testcase001;

        begin
            $display("Testcase 001: Write to Device 1 (Addr 0x7F00)");
            test_num = test_num + 1;

            PrAddr = 30'h00001FC0;
            PrBe   = 4'b1111;
            PrWD   = 32'hDEADBEEF;
            Dev1_RD = 32'h0;
            Dev2_RD = 32'h0;
            Dev1_Irq = 0;
            Dev2_Irq = 0;


            #1;



            check_outputs(1'b1, 1'b0, 2'b00, 32'hDEADBEEF, 6'b000000, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Read from Device 1 (Addr 0x7F04)");
            test_num = test_num + 1;
            PrAddr = 30'h00001FC1;
            PrBe   = 4'b0000;
            PrWD   = 32'h0;
            Dev1_RD = 32'h12345678;
            Dev2_RD = 32'h0;
            Dev1_Irq = 0;
            Dev2_Irq = 0;


            #1;



            check_outputs(1'b0, 1'b0, 2'b01, 32'h0, 6'b000000, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write to Device 2 (Addr 0x7F10)");
            test_num = test_num + 1;
            PrAddr = 30'h00001FC4;
            PrBe   = 4'b1111;
            PrWD   = 32'hCAFEBABE;
            Dev1_RD = 32'h0;
            Dev2_RD = 32'h0;
            Dev1_Irq = 0;
            Dev2_Irq = 0;


            #1;



            check_outputs(1'b0, 1'b1, 2'b00, 32'hCAFEBABE, 6'b000000, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read from Device 2 (Addr 0x7F18)");
            test_num = test_num + 1;
            PrAddr = 30'h00001FC6;
            PrBe   = 4'b0000;
            PrWD   = 32'h0;
            Dev1_RD = 32'h0;
            Dev2_RD = 32'h87654321;
            Dev1_Irq = 0;
            Dev2_Irq = 0;


            #1;



            check_outputs(1'b0, 1'b0, 2'b10, 32'h0, 6'b000000, 32'h87654321);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Interrupt Handling (Both IRQs active)");
            test_num = test_num + 1;
            PrAddr = 30'h0;
            PrBe   = 4'b0;
            Dev1_Irq = 1;
            Dev2_Irq = 1;


            #1;



            check_outputs(1'b0, 1'b0, 2'b00, 32'h0, 6'h0C, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Out of Range Address");
            test_num = test_num + 1;
            PrAddr = 30'hFFFFFFFF;
            PrBe   = 4'b1111;
            PrWD   = 32'hFFFFFFFF;
            Dev1_RD = 32'h11111111;
            Dev2_RD = 32'h22222222;
            Dev1_Irq = 0;
            Dev2_Irq = 0;


            #1;



            check_outputs(1'b0, 1'b0, 2'b11, 32'hFFFFFFFF, 6'h00, 32'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Device 1 address but no Write Enable (PrBe=0)");
            test_num = test_num + 1;
            PrAddr = 30'h00001FC0;
            PrBe   = 4'b0000;
            PrWD   = 32'hAAAAAAAA;
            Dev1_RD = 32'h55555555;


            #1;



            check_outputs(1'b0, 1'b0, 2'b00, 32'hAAAAAAAA, 6'h00, 32'h55555555);
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
        input expected_Dev1_WE;
        input expected_Dev2_WE;
        input [1:0] expected_DevAddr;
        input [31:0] expected_DevWd;
        input [5:0] expected_HWInt;
        input [31:0] expected_PrRD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dev1_WE === (expected_Dev1_WE ^ Dev1_WE ^ expected_Dev1_WE) &&
                expected_Dev2_WE === (expected_Dev2_WE ^ Dev2_WE ^ expected_Dev2_WE) &&
                expected_DevAddr === (expected_DevAddr ^ DevAddr ^ expected_DevAddr) &&
                expected_DevWd === (expected_DevWd ^ DevWd ^ expected_DevWd) &&
                expected_HWInt === (expected_HWInt ^ HWInt ^ expected_HWInt) &&
                expected_PrRD === (expected_PrRD ^ PrRD ^ expected_PrRD)) begin
                $display("PASS");
                $display("  Outputs: Dev1_WE=%b, Dev2_WE=%b, DevAddr=%h, DevWd=%h, HWInt=%h, PrRD=%h",
                         Dev1_WE, Dev2_WE, DevAddr, DevWd, HWInt, PrRD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dev1_WE=%b, Dev2_WE=%b, DevAddr=%h, DevWd=%h, HWInt=%h, PrRD=%h",
                         expected_Dev1_WE, expected_Dev2_WE, expected_DevAddr, expected_DevWd, expected_HWInt, expected_PrRD);
                $display("  Got:      Dev1_WE=%b, Dev2_WE=%b, DevAddr=%h, DevWd=%h, HWInt=%h, PrRD=%h",
                         Dev1_WE, Dev2_WE, DevAddr, DevWd, HWInt, PrRD);
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
