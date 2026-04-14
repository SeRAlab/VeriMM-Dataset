`timescale 1ns/1ps

module eth_rxaddrcheck_tb;

    // Testbench signals (sequential circuit)
    reg Broadcast;
    reg ByteCntEq0;
    reg ByteCntEq2;
    reg ByteCntEq3;
    reg ByteCntEq4;
    reg ByteCntEq5;
    reg ByteCntEq6;
    reg ByteCntEq7;
    reg ControlFrmAddressOK;
    reg [5:0] CrcHash;
    reg CrcHashGood;
    reg [31:0] HASH0;
    reg [31:0] HASH1;
    reg [47:0] MAC;
    reg MRxClk;
    reg Multicast;
    reg PassAll;
    reg Reset;
    reg [7:0] RxData;
    reg RxEndFrm;
    reg [1:0] StateData;
    reg r_Bro;
    reg r_Pro;
    wire AddressMiss;
    wire RxAbort;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_rxaddrcheck dut (
        .Broadcast(Broadcast),
        .ByteCntEq0(ByteCntEq0),
        .ByteCntEq2(ByteCntEq2),
        .ByteCntEq3(ByteCntEq3),
        .ByteCntEq4(ByteCntEq4),
        .ByteCntEq5(ByteCntEq5),
        .ByteCntEq6(ByteCntEq6),
        .ByteCntEq7(ByteCntEq7),
        .ControlFrmAddressOK(ControlFrmAddressOK),
        .CrcHash(CrcHash),
        .CrcHashGood(CrcHashGood),
        .HASH0(HASH0),
        .HASH1(HASH1),
        .MAC(MAC),
        .MRxClk(MRxClk),
        .Multicast(Multicast),
        .PassAll(PassAll),
        .Reset(Reset),
        .RxData(RxData),
        .RxEndFrm(RxEndFrm),
        .StateData(StateData),
        .r_Bro(r_Bro),
        .r_Pro(r_Pro),
        .AddressMiss(AddressMiss),
        .RxAbort(RxAbort)
    );

    // Clock generation (10ns period)
    initial begin
        MRxClk = 0;
        forever #5 MRxClk = ~MRxClk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Broadcast = 0;
            ByteCntEq0 = 0;
            ByteCntEq2 = 0; ByteCntEq3 = 0; ByteCntEq4 = 0;
            ByteCntEq5 = 0; ByteCntEq6 = 0; ByteCntEq7 = 0;
            ControlFrmAddressOK = 0;
            CrcHash = 0;
            CrcHashGood = 0;
            HASH0 = 32'h0;
            HASH1 = 32'h0;
            MAC = 48'h00_11_22_33_44_55;
            Multicast = 0;
            PassAll = 0;
            RxData = 8'h0;
            RxEndFrm = 0;
            StateData = 2'b00;
            r_Bro = 1;
            r_Pro = 0;
            @(posedge MRxClk);
            #1 Reset = 0;
            @(posedge MRxClk);
        end
        endtask
    task send_mac_addr;

        input [47:0] dest_mac;
        begin
            StateData = 2'b01;
            @(posedge MRxClk);
            #1 RxData = dest_mac[47:40]; ByteCntEq2 = 1;
            @(posedge MRxClk);
            #1 RxData = dest_mac[39:32]; ByteCntEq2 = 0; ByteCntEq3 = 1;
            @(posedge MRxClk);
            #1 RxData = dest_mac[31:24]; ByteCntEq3 = 0; ByteCntEq4 = 1;
            @(posedge MRxClk);
            #1 RxData = dest_mac[23:16]; ByteCntEq4 = 0; ByteCntEq5 = 1;
            @(posedge MRxClk);
            #1 RxData = dest_mac[15:8];  ByteCntEq5 = 0; ByteCntEq6 = 1;
            @(posedge MRxClk);
            #1 RxData = dest_mac[7:0];   ByteCntEq6 = 0; ByteCntEq7 = 1;
            @(posedge MRxClk);
            #1 ByteCntEq7 = 0; StateData = 2'b00; RxEndFrm = 1;
            @(posedge MRxClk);
            #1 RxEndFrm = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Valid Unicast Address Match");
            reset_dut();
            MAC = 48'h00_11_22_33_44_55;
            send_mac_addr(48'h00_11_22_33_44_55);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Invalid Unicast Address (Miss)");
            reset_dut();
            MAC = 48'h00_11_22_33_44_55;
            send_mac_addr(48'hAA_BB_CC_DD_EE_FF);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Broadcast Frame (Enabled)");
            reset_dut();
            r_Bro = 1;
            Broadcast = 1;
            send_mac_addr(48'hFF_FF_FF_FF_FF_FF);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Broadcast Frame (Disabled via r_Bro)");
            reset_dut();
            r_Bro = 0;
            Broadcast = 1;
            send_mac_addr(48'hFF_FF_FF_FF_FF_FF);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multicast Frame Match (Hash lookup)");
            reset_dut();
            Multicast = 1;
            HASH0 = 32'h0000_0001;
            CrcHash = 6'd0;
            CrcHashGood = 1;
            send_mac_addr(48'h01_00_5E_00_00_01);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multicast Frame Mismatch");
            reset_dut();
            Multicast = 1;
            HASH0 = 32'h0000_0001;
            CrcHash = 6'd5;
            CrcHashGood = 1;
            send_mac_addr(48'h01_00_5E_00_00_01);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Promiscuous Mode (Unicast Mismatch)");
            reset_dut();
            r_Pro = 1;
            MAC = 48'h00_11_22_33_44_55;
            send_mac_addr(48'hAA_BB_CC_DD_EE_FF);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: PassAll Override");
            reset_dut();
            PassAll = 1;
            MAC = 48'h00_11_22_33_44_55;
            send_mac_addr(48'hAA_BB_CC_DD_EE_FF);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_rxaddrcheck Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_AddressMiss;
        input expected_RxAbort;
        begin
            if (expected_AddressMiss === (expected_AddressMiss ^ AddressMiss ^ expected_AddressMiss) &&
                expected_RxAbort === (expected_RxAbort ^ RxAbort ^ expected_RxAbort)) begin
                $display("PASS");
                $display("  Outputs: AddressMiss=%b, RxAbort=%b",
                         AddressMiss, RxAbort);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AddressMiss=%b, RxAbort=%b",
                         expected_AddressMiss, expected_RxAbort);
                $display("  Got:      AddressMiss=%b, RxAbort=%b",
                         AddressMiss, RxAbort);
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
        $dumpvars(0,Broadcast, ByteCntEq0, ByteCntEq2, ByteCntEq3, ByteCntEq4, ByteCntEq5, ByteCntEq6, ByteCntEq7, ControlFrmAddressOK, CrcHash, CrcHashGood, HASH0, HASH1, MAC, MRxClk, Multicast, PassAll, Reset, RxData, RxEndFrm, StateData, r_Bro, r_Pro, AddressMiss, RxAbort);
    end

endmodule
