`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] AL;
    wire ACIA;
    wire BasicRom;
    wire KeyBoardPort;
    wire MonitorRom;
    wire Ram;
    wire VideoMem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AL(AL),
        .ACIA(ACIA),
        .BasicRom(BasicRom),
        .KeyBoardPort(KeyBoardPort),
        .MonitorRom(MonitorRom),
        .Ram(Ram),
        .VideoMem(VideoMem)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing RAM region (address 0x0000)", test_num);
        AL = 16'h0000;

        #1;


        check_outputs(0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing Video Memory region (address 16'h1000)", test_num);
        AL = 16'h1000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing Basic ROM region (address 16'hA000)", test_num);
        AL = 16'hA000;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing Keyboard Port region (address 16'hD000)", test_num);
        AL = 16'hD000;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing ACIA region (address 16'hF000)", test_num);
        AL = 16'hF000;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing Monitor ROM region (address 16'hF800)", test_num);
        AL = 16'hF800;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing upper bound of Monitor ROM (address 16'hFFFF)", test_num);
        AL = 16'hFFFF;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing unmapped address region (address 16'h4000)", test_num);
        AL = 16'h4000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Testing mid-range RAM address (address 16'h02FF)", test_num);
        AL = 16'h02FF;
        #1;

        check_outputs(0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Testing mid-range Basic ROM address (address 16'hBFFF)", test_num);
        AL = 16'hBFFF;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0);
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
        input expected_ACIA;
        input expected_BasicRom;
        input expected_KeyBoardPort;
        input expected_MonitorRom;
        input expected_Ram;
        input expected_VideoMem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ACIA === (expected_ACIA ^ ACIA ^ expected_ACIA) &&
                expected_BasicRom === (expected_BasicRom ^ BasicRom ^ expected_BasicRom) &&
                expected_KeyBoardPort === (expected_KeyBoardPort ^ KeyBoardPort ^ expected_KeyBoardPort) &&
                expected_MonitorRom === (expected_MonitorRom ^ MonitorRom ^ expected_MonitorRom) &&
                expected_Ram === (expected_Ram ^ Ram ^ expected_Ram) &&
                expected_VideoMem === (expected_VideoMem ^ VideoMem ^ expected_VideoMem)) begin
                $display("PASS");
                $display("  Outputs: ACIA=%b, BasicRom=%b, KeyBoardPort=%b, MonitorRom=%b, Ram=%b, VideoMem=%b",
                         ACIA, BasicRom, KeyBoardPort, MonitorRom, Ram, VideoMem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACIA=%b, BasicRom=%b, KeyBoardPort=%b, MonitorRom=%b, Ram=%b, VideoMem=%b",
                         expected_ACIA, expected_BasicRom, expected_KeyBoardPort, expected_MonitorRom, expected_Ram, expected_VideoMem);
                $display("  Got:      ACIA=%b, BasicRom=%b, KeyBoardPort=%b, MonitorRom=%b, Ram=%b, VideoMem=%b",
                         ACIA, BasicRom, KeyBoardPort, MonitorRom, Ram, VideoMem);
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
