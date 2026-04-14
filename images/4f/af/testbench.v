`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ADD1;
    reg ADD2;
    reg ADD3;
    reg ADD4;
    reg CLK;
    reg CPU_RTS1;
    reg CPU_TXD1;
    reg NRST;
    reg RXD0;
    reg RXD1;
    reg RXD2;
    reg RXD3;
    reg RXD4;
    reg RXD5;
    reg RXD6;
    reg RXD7;
    wire CPU_RXD1;
    wire RTS0;
    wire RTS1;
    wire RTS2;
    wire RTS3;
    wire RTS4;
    wire RTS5;
    wire RTS6;
    wire RTS7;
    wire TXD0;
    wire TXD1;
    wire TXD2;
    wire TXD3;
    wire TXD4;
    wire TXD5;
    wire TXD6;
    wire TXD7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADD1(ADD1),
        .ADD2(ADD2),
        .ADD3(ADD3),
        .ADD4(ADD4),
        .CLK(CLK),
        .CPU_RTS1(CPU_RTS1),
        .CPU_TXD1(CPU_TXD1),
        .NRST(NRST),
        .RXD0(RXD0),
        .RXD1(RXD1),
        .RXD2(RXD2),
        .RXD3(RXD3),
        .RXD4(RXD4),
        .RXD5(RXD5),
        .RXD6(RXD6),
        .RXD7(RXD7),
        .CPU_RXD1(CPU_RXD1),
        .RTS0(RTS0),
        .RTS1(RTS1),
        .RTS2(RTS2),
        .RTS3(RTS3),
        .RTS4(RTS4),
        .RTS5(RTS5),
        .RTS6(RTS6),
        .RTS7(RTS7),
        .TXD0(TXD0),
        .TXD1(TXD1),
        .TXD2(TXD2),
        .TXD3(TXD3),
        .TXD4(TXD4),
        .TXD5(TXD5),
        .TXD6(TXD6),
        .TXD7(TXD7)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Channel 0 Selection (Address 0000)", test_num);

        NRST = 0; CLK = 0;
        CPU_TXD1 = 1; CPU_RTS1 = 0;
        ADD1 = 0; ADD2 = 0; ADD3 = 0; ADD4 = 0;
        RXD0 = 0; RXD1 = 1; RXD2 = 1; RXD3 = 1; RXD4 = 1; RXD5 = 1; RXD6 = 1; RXD7 = 1;
        #10; NRST = 1; #10;


        CPU_TXD1 = 0; CPU_RTS1 = 1; RXD0 = 0;
        #10; CLK = 1; #10; CLK = 0; #10;


        #1;



        check_outputs(0, 1,0,0,0,0,0,0,0, 0,1,1,1,1,1,1,1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Channel 1 Selection (Address 0001)", test_num);
        NRST = 0; #10; NRST = 1;


        ADD1 = 1; ADD2 = 0; ADD3 = 0; ADD4 = 0;
        CPU_TXD1 = 1; CPU_RTS1 = 1; RXD1 = 0;
        #10; CLK = 1; #10; CLK = 0; #10;


        #1;



        check_outputs(0, 0,1,0,0,0,0,0,0, 1,1,1,1,1,1,1,1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Channel 3 Selection (Address 0011)", test_num);
        NRST = 0; #10; NRST = 1;


        ADD1 = 1; ADD2 = 1; ADD3 = 0; ADD4 = 0;
        CPU_TXD1 = 0; CPU_RTS1 = 1; RXD3 = 1;
        #10; CLK = 1; #10; CLK = 0; #10;


        #1;



        check_outputs(1, 0,0,0,1,0,0,0,0, 1,1,1,0,1,1,1,1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Channel 7 Selection (Address 0111)", test_num);
        NRST = 0; #10; NRST = 1;


        ADD1 = 1; ADD2 = 1; ADD3 = 1; ADD4 = 0;
        CPU_TXD1 = 1; CPU_RTS1 = 1; RXD7 = 0;
        #10; CLK = 1; #10; CLK = 0; #10;


        #1;



        check_outputs(0, 0,0,0,0,0,0,0,1, 1,1,1,1,1,1,1,1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verify Isolation (Switching Ch 4)", test_num);
        NRST = 0; #10; NRST = 1;


        ADD1 = 0; ADD2 = 0; ADD3 = 1; ADD4 = 0;
        CPU_TXD1 = 0; CPU_RTS1 = 1; RXD4 = 1;
        #10; CLK = 1; #10; CLK = 0; #10;


        #1;



        check_outputs(1, 0,0,0,0,1,0,0,0, 1,1,1,1,0,1,1,1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Channel 2 Selection and Data Toggle", test_num);
        NRST = 0; #10; NRST = 1;


        ADD1 = 0; ADD2 = 1; ADD3 = 0; ADD4 = 0;
        CPU_TXD1 = 1; CPU_RTS1 = 0; RXD2 = 1;
        #10; CLK = 1; #10; CLK = 0; #10;


        #1;



        check_outputs(1, 0,0,0,0,0,0,0,0, 1,1,1,1,1,1,1,1);
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
        input expected_CPU_RXD1;
        input expected_RTS0;
        input expected_RTS1;
        input expected_RTS2;
        input expected_RTS3;
        input expected_RTS4;
        input expected_RTS5;
        input expected_RTS6;
        input expected_RTS7;
        input expected_TXD0;
        input expected_TXD1;
        input expected_TXD2;
        input expected_TXD3;
        input expected_TXD4;
        input expected_TXD5;
        input expected_TXD6;
        input expected_TXD7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CPU_RXD1 === (expected_CPU_RXD1 ^ CPU_RXD1 ^ expected_CPU_RXD1) &&
                expected_RTS0 === (expected_RTS0 ^ RTS0 ^ expected_RTS0) &&
                expected_RTS1 === (expected_RTS1 ^ RTS1 ^ expected_RTS1) &&
                expected_RTS2 === (expected_RTS2 ^ RTS2 ^ expected_RTS2) &&
                expected_RTS3 === (expected_RTS3 ^ RTS3 ^ expected_RTS3) &&
                expected_RTS4 === (expected_RTS4 ^ RTS4 ^ expected_RTS4) &&
                expected_RTS5 === (expected_RTS5 ^ RTS5 ^ expected_RTS5) &&
                expected_RTS6 === (expected_RTS6 ^ RTS6 ^ expected_RTS6) &&
                expected_RTS7 === (expected_RTS7 ^ RTS7 ^ expected_RTS7) &&
                expected_TXD0 === (expected_TXD0 ^ TXD0 ^ expected_TXD0) &&
                expected_TXD1 === (expected_TXD1 ^ TXD1 ^ expected_TXD1) &&
                expected_TXD2 === (expected_TXD2 ^ TXD2 ^ expected_TXD2) &&
                expected_TXD3 === (expected_TXD3 ^ TXD3 ^ expected_TXD3) &&
                expected_TXD4 === (expected_TXD4 ^ TXD4 ^ expected_TXD4) &&
                expected_TXD5 === (expected_TXD5 ^ TXD5 ^ expected_TXD5) &&
                expected_TXD6 === (expected_TXD6 ^ TXD6 ^ expected_TXD6) &&
                expected_TXD7 === (expected_TXD7 ^ TXD7 ^ expected_TXD7)) begin
                $display("PASS");
                $display("  Outputs: CPU_RXD1=%b, RTS0=%b, RTS1=%b, RTS2=%b, RTS3=%b, RTS4=%b, RTS5=%b, RTS6=%b, RTS7=%b, TXD0=%b, TXD1=%b, TXD2=%b, TXD3=%b, TXD4=%b, TXD5=%b, TXD6=%b, TXD7=%b",
                         CPU_RXD1, RTS0, RTS1, RTS2, RTS3, RTS4, RTS5, RTS6, RTS7, TXD0, TXD1, TXD2, TXD3, TXD4, TXD5, TXD6, TXD7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CPU_RXD1=%b, RTS0=%b, RTS1=%b, RTS2=%b, RTS3=%b, RTS4=%b, RTS5=%b, RTS6=%b, RTS7=%b, TXD0=%b, TXD1=%b, TXD2=%b, TXD3=%b, TXD4=%b, TXD5=%b, TXD6=%b, TXD7=%b",
                         expected_CPU_RXD1, expected_RTS0, expected_RTS1, expected_RTS2, expected_RTS3, expected_RTS4, expected_RTS5, expected_RTS6, expected_RTS7, expected_TXD0, expected_TXD1, expected_TXD2, expected_TXD3, expected_TXD4, expected_TXD5, expected_TXD6, expected_TXD7);
                $display("  Got:      CPU_RXD1=%b, RTS0=%b, RTS1=%b, RTS2=%b, RTS3=%b, RTS4=%b, RTS5=%b, RTS6=%b, RTS7=%b, TXD0=%b, TXD1=%b, TXD2=%b, TXD3=%b, TXD4=%b, TXD5=%b, TXD6=%b, TXD7=%b",
                         CPU_RXD1, RTS0, RTS1, RTS2, RTS3, RTS4, RTS5, RTS6, RTS7, TXD0, TXD1, TXD2, TXD3, TXD4, TXD5, TXD6, TXD7);
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
