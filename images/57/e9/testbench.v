`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClock;
    reg [7:0] iNR50;
    reg [7:0] iNR51;
    reg iOsc262k;
    reg [4:0] iOut1;
    reg [4:0] iOut2;
    reg [4:0] iOut3;
    reg [4:0] iOut4;
    reg iReset;
    wire oChClk;
    wire [1:0] oChSel;
    wire [4:0] oSO1;
    wire [4:0] oSO2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClock(iClock),
        .iNR50(iNR50),
        .iNR51(iNR51),
        .iOsc262k(iOsc262k),
        .iOut1(iOut1),
        .iOut2(iOut2),
        .iOut3(iOut3),
        .iOut4(iOut4),
        .iReset(iReset),
        .oChClk(oChClk),
        .oChSel(oChSel),
        .oSO1(oSO1),
        .oSO2(oSO2)
    );

    // Clock generation (10ns period)
    initial begin
        iClock = 0;
        forever #5 iClock = ~iClock;
    end

        task reset_dut;

        begin
            iReset = 1;
            iNR50 = 8'h00;
            iNR51 = 8'h00;
            iOsc262k = 0;
            iOut1 = 5'h00;
            iOut2 = 5'h00;
            iOut3 = 5'h00;
            iOut4 = 5'h00;
            #20;
            iReset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Zero Inputs", test_num);
            reset_dut();


            repeat(10) @(posedge iClock);


            #1;



            check_outputs(1'b0, 2'b00, 5'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 1 Routing to SO1", test_num);
            reset_dut();

            iNR50 = 8'h07;
            iNR51 = 8'h01;
            iOut1 = 5'h1F;
            iOut2 = 5'h0A;


            repeat(16) begin
                iOsc262k = ~iOsc262k;
                repeat(4) @(posedge iClock);
            end




            if (oSO1 > 0 && oSO2 == 0)
                pass_count = pass_count + 1;
            else begin
                $display("FAIL: SO1 should be active, SO2 should be zero. Got SO1=%h, SO2=%h", oSO1, oSO2);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 2 Routing to SO2", test_num);
            reset_dut();

            iNR50 = 8'h70;
            iNR51 = 8'h20;
            iOut2 = 5'h10;

            repeat(16) begin
                iOsc262k = ~iOsc262k;
                repeat(4) @(posedge iClock);
            end

            if (oSO2 > 0 && oSO1 == 0)
                pass_count = pass_count + 1;
            else begin
                $display("FAIL: SO2 should be active, SO1 should be zero. Got SO1=%h, SO2=%h", oSO1, oSO2);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg found_sel0, found_sel1, found_sel2, found_sel3;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel Selector Activity", test_num);
            reset_dut();
            found_sel0 = 0; found_sel1 = 0; found_sel2 = 0; found_sel3 = 0;


            repeat(100) begin
                @(posedge iClock);
                iOsc262k = ( $time % 40 == 0 ) ? ~iOsc262k : iOsc262k;
                case(oChSel)
                    2'b00: found_sel0 = 1;
                    2'b01: found_sel1 = 1;
                    2'b10: found_sel2 = 1;
                    2'b11: found_sel3 = 1;
                endcase
            end

            if (found_sel0 && found_sel1 && found_sel2 && found_sel3) begin
                $display("PASS: All channel selections observed");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Missing oChSel states. 0:%b 1:%b 2:%b 3:%b", found_sel0, found_sel1, found_sel2, found_sel3);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [4:0] single_ch_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixing Multiple Channels", test_num);


            reset_dut();
            iNR50 = 8'h77; iNR51 = 8'h01; iOut1 = 5'h08;
            repeat(32) begin iOsc262k = ~iOsc262k; @(posedge iClock); end
            single_ch_val = oSO1;


            iNR51 = 8'h05;
            iOut3 = 5'h08;
            repeat(32) begin iOsc262k = ~iOsc262k; @(posedge iClock); end

            if (oSO1 > single_ch_val) begin
                $display("PASS: Mixing increased output magnitude");
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Mixed output %h not greater than single channel %h", oSO1, single_ch_val);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        reg [4:0] high_vol_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NR50 Volume Scaling", test_num);
            reset_dut();


            iNR50 = 8'h07; iNR51 = 8'h0F;
            iOut1 = 5'h10; iOut2 = 5'h10; iOut3 = 5'h10; iOut4 = 5'h10;
            repeat(32) begin iOsc262k = ~iOsc262k; @(posedge iClock); end
            high_vol_val = oSO1;


            iNR50 = 8'h01;
            repeat(32) begin iOsc262k = ~iOsc262k; @(posedge iClock); end

            if (oSO1 < high_vol_val && oSO1 > 0) begin
                $display("PASS: Volume scaling functional");
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Volume scaling failed. High: %h, Low: %h", high_vol_val, oSO1);
                fail_count = fail_count + 1;
            end
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
        input expected_oChClk;
        input [1:0] expected_oChSel;
        input [4:0] expected_oSO1;
        input [4:0] expected_oSO2;
        begin
            if (expected_oChClk === (expected_oChClk ^ oChClk ^ expected_oChClk) &&
                expected_oChSel === (expected_oChSel ^ oChSel ^ expected_oChSel) &&
                expected_oSO1 === (expected_oSO1 ^ oSO1 ^ expected_oSO1) &&
                expected_oSO2 === (expected_oSO2 ^ oSO2 ^ expected_oSO2)) begin
                $display("PASS");
                $display("  Outputs: oChClk=%b, oChSel=%h, oSO1=%h, oSO2=%h",
                         oChClk, oChSel, oSO1, oSO2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oChClk=%b, oChSel=%h, oSO1=%h, oSO2=%h",
                         expected_oChClk, expected_oChSel, expected_oSO1, expected_oSO2);
                $display("  Got:      oChClk=%b, oChSel=%h, oSO1=%h, oSO2=%h",
                         oChClk, oChSel, oSO1, oSO2);
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
        $dumpvars(0,iClock, iNR50, iNR51, iOsc262k, iOut1, iOut2, iOut3, iOut4, iReset, oChClk, oChSel, oSO1, oSO2);
    end

endmodule
