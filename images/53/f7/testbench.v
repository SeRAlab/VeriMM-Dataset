`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg E_IP;
    reg E_OR;
    reg E_PC;
    reg E_R0;
    reg E_RN;
    reg E_SP;
    reg RD;
    reg [15:0] ioOut;
    reg [15:0] memOut;
    reg [15:0] orOut;
    reg [15:0] pcOut;
    reg [15:0] raOut;
    reg [15:0] spOut;
    wire [15:0] dataBus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E_IP(E_IP),
        .E_OR(E_OR),
        .E_PC(E_PC),
        .E_R0(E_R0),
        .E_RN(E_RN),
        .E_SP(E_SP),
        .RD(RD),
        .ioOut(ioOut),
        .memOut(memOut),
        .orOut(orOut),
        .pcOut(pcOut),
        .raOut(raOut),
        .spOut(spOut),
        .dataBus(dataBus)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All enable signals inactive (Expect 0x0000)", test_num);
            RD = 0; E_PC = 0; E_SP = 0; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 0;
            pcOut = 16'h1111; memOut = 16'h2222; orOut = 16'h3333;
            spOut = 16'h4444; raOut = 16'h5555; ioOut = 16'h6666;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: RD active (Expect memOut)", test_num);
            RD = 1; E_PC = 0; E_SP = 0; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: E_PC active (Expect pcOut)", test_num);
            RD = 0; E_PC = 1; E_SP = 0; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: E_SP active (Expect spOut)", test_num);
            RD = 0; E_PC = 0; E_SP = 1; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: E_IP active (Expect ioOut)", test_num);
            RD = 0; E_PC = 0; E_SP = 0; E_IP = 1; E_OR = 0; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h6666);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: E_OR active (Expect orOut)", test_num);
            RD = 0; E_PC = 0; E_SP = 0; E_IP = 0; E_OR = 1; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: E_R0 active (Expect raOut)", test_num);
            RD = 0; E_PC = 0; E_SP = 0; E_IP = 0; E_OR = 0; E_R0 = 1; E_RN = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: E_RN active (Expect raOut)", test_num);
            RD = 0; E_PC = 0; E_SP = 0; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Priority Check RD vs E_PC (Expect memOut)", test_num);
            RD = 1; E_PC = 1; E_SP = 0; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Priority Check E_PC vs E_SP (Expect pcOut)", test_num);
            RD = 0; E_PC = 1; E_SP = 1; E_IP = 0; E_OR = 0; E_R0 = 0; E_RN = 0;
            #1;

            check_outputs(16'h1111);
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
        input [15:0] expected_dataBus;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataBus === (expected_dataBus ^ dataBus ^ expected_dataBus)) begin
                $display("PASS");
                $display("  Outputs: dataBus=%h",
                         dataBus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataBus=%h",
                         expected_dataBus);
                $display("  Got:      dataBus=%h",
                         dataBus);
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
