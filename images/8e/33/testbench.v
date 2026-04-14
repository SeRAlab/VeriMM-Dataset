`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] DMEM;
    reg [31:0] EthData1;
    reg [31:0] EthData2;
    reg [31:0] EthNew;
    reg [31:0] EthSendFinish;
    reg [31:0] Random;
    reg [31:0] Switch;
    reg [31:0] Timer;
    reg [31:0] addr;
    wire [31:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DMEM(DMEM),
        .EthData1(EthData1),
        .EthData2(EthData2),
        .EthNew(EthNew),
        .EthSendFinish(EthSendFinish),
        .Random(Random),
        .Switch(Switch),
        .Timer(Timer),
        .addr(addr),
        .rdata(rdata)
    );
    task init_signals;

        begin
            DMEM          = 32'hAAAA_0000;
            Random        = 32'hBBBB_1111;
            Switch        = 32'hCCCC_2222;
            Timer         = 32'hDDDD_3333;
            EthNew        = 32'hEEEE_4444;
            EthData1      = 32'hFFFF_5555;
            EthData2      = 32'h0000_6666;
            EthSendFinish = 32'h1111_7777;
            addr          = 32'h0;
        end
        endtask

    task testcase001;

    begin
        init_signals();
        $display("Running testcase001: Access DMEM (Addr=0x0)");
        addr = 32'h0000_0000;
        #1;

        check_outputs(DMEM);
    end
        endtask

    task testcase002;

    begin
        init_signals();
        $display("Running testcase002: Access DMEM (Addr=0x7FF)");
        addr = 32'h0000_07FF;
        #1;

        check_outputs(DMEM);
    end
        endtask

    task testcase003;

    begin
        init_signals();
        $display("Running testcase003: Select Random (Addr=0x800)");
        addr = 32'h0000_0800;
        #1;

        check_outputs(Random);
    end
        endtask

    task testcase004;

    begin
        init_signals();
        $display("Running testcase004: Select Switch (Addr=0x804)");
        addr = 32'h0000_0804;
        #1;

        check_outputs(Switch);
    end
        endtask

    task testcase005;

    begin
        init_signals();
        $display("Running testcase005: Select Timer (Addr=0x808)");
        addr = 32'h0000_0808;
        #1;

        check_outputs(Timer);
    end
        endtask

    task testcase006;

    begin
        init_signals();
        $display("Running testcase006: Select EthNew (Addr=0x810)");
        addr = 32'h0000_0810;
        #1;

        check_outputs(EthNew);
    end
        endtask

    task testcase007;

    begin
        init_signals();
        $display("Running testcase007: Select EthData1 (Addr=0x814)");
        addr = 32'h0000_0814;
        #1;

        check_outputs(EthData1);
    end
        endtask

    task testcase008;

    begin
        init_signals();
        $display("Running testcase008: Select EthData2 (Addr=0x818)");
        addr = 32'h0000_0818;
        #1;

        check_outputs(EthData2);
    end
        endtask

    task testcase009;

    begin
        init_signals();
        $display("Running testcase009: Select EthSendFinish (Addr=0x81C)");
        addr = 32'h0000_081C;
        #1;

        check_outputs(EthSendFinish);
    end
        endtask

    task testcase010;

    begin
        init_signals();
        $display("Running testcase010: Access DMEM with high bits set (Addr=0xFFFF_F7FF)");
        addr = 32'hFFFF_F7FF;
        #1;

        check_outputs(DMEM);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_rdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
