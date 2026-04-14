`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] ADDR;
    reg [1:0] CFG;
    reg CI;
    reg [23:0] CVALID;
    reg DC_ILO;
    reg ENDRAM;
    reg INVAL_L;
    reg [3:0] IOSEL;
    reg KDET;
    reg MMU_HIT;
    reg [15:0] TAG0;
    reg [15:0] TAG1;
    reg WRITE;
    wire CA_HIT;
    wire CA_SET;
    wire IO_SPACE;
    wire KILL;
    wire [23:0] UPDATE;
    wire USE_CA;
    wire WB_ACC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CFG(CFG),
        .CI(CI),
        .CVALID(CVALID),
        .DC_ILO(DC_ILO),
        .ENDRAM(ENDRAM),
        .INVAL_L(INVAL_L),
        .IOSEL(IOSEL),
        .KDET(KDET),
        .MMU_HIT(MMU_HIT),
        .TAG0(TAG0),
        .TAG1(TAG1),
        .WRITE(WRITE),
        .CA_HIT(CA_HIT),
        .CA_SET(CA_SET),
        .IO_SPACE(IO_SPACE),
        .KILL(KILL),
        .UPDATE(UPDATE),
        .USE_CA(USE_CA),
        .WB_ACC(WB_ACC)
    );
    task testcase001;

    begin
        test_num = 1;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        TAG1 = 16'hFFFF;
        CVALID = 24'hFFFFFF;
        MMU_HIT = 1'b1;
        CI = 1'b0;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;
        DC_ILO = 1'b0;
        INVAL_L = 1'b1;
        WRITE = 1'b0;
        CFG = 2'b00;
        KDET = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 24'hFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ADDR = 24'hABCDEF;
        TAG0 = 16'h0000;
        TAG1 = 16'hABCD;
        CVALID = 24'hFFFFFF;
        MMU_HIT = 1'b1;
        CI = 1'b0;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;
        DC_ILO = 1'b0;
        INVAL_L = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 24'hFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ADDR = 24'h112233;
        TAG0 = 16'hAAAA;
        TAG1 = 16'hBBBB;
        CVALID = 24'hFFFFFF;
        MMU_HIT = 1'b1;
        CI = 1'b0;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;
        DC_ILO = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 24'hFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        TAG1 = 16'h0000;
        CVALID = 24'hFFFFFF;
        MMU_HIT = 1'b1;
        CI = 1'b0;
        IOSEL = 4'h5;
        ENDRAM = 1'b1;
        DC_ILO = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 24'hFFFFFF, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        MMU_HIT = 1'b1;
        CI = 1'b1;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 24'hFFFFFF, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        MMU_HIT = 1'b0;
        CI = 1'b0;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 24'hFFFFFF, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        WRITE = 1'b1;
        MMU_HIT = 1'b1;
        CI = 1'b0;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 24'hFFFFFF, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        INVAL_L = 1'b0;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        CVALID = 24'hFFFFFF;
        MMU_HIT = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 24'hFFFFFE, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        KDET = 1'b1;
        ADDR = 24'h000000;
        MMU_HIT = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 24'hFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ADDR = 24'h123456;
        TAG0 = 16'h1234;
        CVALID = 24'h000000;
        MMU_HIT = 1'b1;
        CI = 1'b0;
        IOSEL = 4'h0;
        ENDRAM = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 24'h000000, 1'b1, 1'b0);
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
        input expected_CA_HIT;
        input expected_CA_SET;
        input expected_IO_SPACE;
        input expected_KILL;
        input [23:0] expected_UPDATE;
        input expected_USE_CA;
        input expected_WB_ACC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CA_HIT === (expected_CA_HIT ^ CA_HIT ^ expected_CA_HIT) &&
                expected_CA_SET === (expected_CA_SET ^ CA_SET ^ expected_CA_SET) &&
                expected_IO_SPACE === (expected_IO_SPACE ^ IO_SPACE ^ expected_IO_SPACE) &&
                expected_KILL === (expected_KILL ^ KILL ^ expected_KILL) &&
                expected_UPDATE === (expected_UPDATE ^ UPDATE ^ expected_UPDATE) &&
                expected_USE_CA === (expected_USE_CA ^ USE_CA ^ expected_USE_CA) &&
                expected_WB_ACC === (expected_WB_ACC ^ WB_ACC ^ expected_WB_ACC)) begin
                $display("PASS");
                $display("  Outputs: CA_HIT=%b, CA_SET=%b, IO_SPACE=%b, KILL=%b, UPDATE=%h, USE_CA=%b, WB_ACC=%b",
                         CA_HIT, CA_SET, IO_SPACE, KILL, UPDATE, USE_CA, WB_ACC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CA_HIT=%b, CA_SET=%b, IO_SPACE=%b, KILL=%b, UPDATE=%h, USE_CA=%b, WB_ACC=%b",
                         expected_CA_HIT, expected_CA_SET, expected_IO_SPACE, expected_KILL, expected_UPDATE, expected_USE_CA, expected_WB_ACC);
                $display("  Got:      CA_HIT=%b, CA_SET=%b, IO_SPACE=%b, KILL=%b, UPDATE=%h, USE_CA=%b, WB_ACC=%b",
                         CA_HIT, CA_SET, IO_SPACE, KILL, UPDATE, USE_CA, WB_ACC);
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
