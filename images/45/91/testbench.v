`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ECOREVNUM;
    reg [9:0] PADDR;
    reg PCLK;
    reg PCLKG;
    reg PENABLE;
    reg PRESETn;
    reg PSEL;
    reg [31:0] PWDATA;
    reg PWRITE;
    reg RXD;
    wire BAUDTICK;
    wire [31:0] PRDATA;
    wire PREADY;
    wire PSLVERR;
    wire RXINT;
    wire RXOVRINT;
    wire TXD;
    wire TXEN;
    wire TXINT;
    wire TXOVRINT;
    wire UARTINT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ECOREVNUM(ECOREVNUM),
        .PADDR(PADDR),
        .PCLK(PCLK),
        .PCLKG(PCLKG),
        .PENABLE(PENABLE),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PWDATA(PWDATA),
        .PWRITE(PWRITE),
        .RXD(RXD),
        .BAUDTICK(BAUDTICK),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR),
        .RXINT(RXINT),
        .RXOVRINT(RXOVRINT),
        .TXD(TXD),
        .TXEN(TXEN),
        .TXINT(TXINT),
        .TXOVRINT(TXOVRINT),
        .UARTINT(UARTINT)
    );
    task run_clock;

        input integer cycles;
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) begin
                #5 PCLK = 1; PCLKG = 1;
                #5 PCLK = 0; PCLKG = 0;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);


            PCLK = 0; PCLKG = 0; PRESETn = 0;
            PSEL = 0; PADDR = 0; PENABLE = 0; PWRITE = 0; PWDATA = 0;
            ECOREVNUM = 0; RXD = 1;

            run_clock(5);
            PRESETn = 1;
            run_clock(2);



            #1;




            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: APB Write Transaction (Placeholder Check)", test_num);

            PRESETn = 0; run_clock(2); PRESETn = 1; run_clock(2);


            PSEL = 1;
            PWRITE = 1;
            PADDR = 10'h0A4;
            PWDATA = 32'hAAAA_BBBB;
            PENABLE = 0;
            run_clock(1);

            PENABLE = 1;
            run_clock(1);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);

            PSEL = 0; PENABLE = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: APB Read Transaction (Placeholder Check)", test_num);

            PRESETn = 0; run_clock(2); PRESETn = 1; run_clock(2);


            PSEL = 1;
            PWRITE = 0;
            PADDR = 10'h0F0;
            PENABLE = 0;
            run_clock(1);

            PENABLE = 1;
            run_clock(1);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);

            PSEL = 0; PENABLE = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RXD Input Influence Check", test_num);

            PRESETn = 0; run_clock(2); PRESETn = 1; run_clock(2);


            RXD = 0; run_clock(5);
            RXD = 1; run_clock(5);
            RXD = 0; run_clock(2);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ECOREVNUM and Control Signal Check", test_num);

            PRESETn = 0; run_clock(2); PRESETn = 1; run_clock(2);

            ECOREVNUM = 4'hD;
            PSEL = 1;
            PWRITE = 1;
            PADDR = 10'h3FF;
            PWDATA = 32'hFFFF_FFFF;
            PENABLE = 1;

            run_clock(10);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_BAUDTICK;
        input [31:0] expected_PRDATA;
        input expected_PREADY;
        input expected_PSLVERR;
        input expected_RXINT;
        input expected_RXOVRINT;
        input expected_TXD;
        input expected_TXEN;
        input expected_TXINT;
        input expected_TXOVRINT;
        input expected_UARTINT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BAUDTICK === (expected_BAUDTICK ^ BAUDTICK ^ expected_BAUDTICK) &&
                expected_PRDATA === (expected_PRDATA ^ PRDATA ^ expected_PRDATA) &&
                expected_PREADY === (expected_PREADY ^ PREADY ^ expected_PREADY) &&
                expected_PSLVERR === (expected_PSLVERR ^ PSLVERR ^ expected_PSLVERR) &&
                expected_RXINT === (expected_RXINT ^ RXINT ^ expected_RXINT) &&
                expected_RXOVRINT === (expected_RXOVRINT ^ RXOVRINT ^ expected_RXOVRINT) &&
                expected_TXD === (expected_TXD ^ TXD ^ expected_TXD) &&
                expected_TXEN === (expected_TXEN ^ TXEN ^ expected_TXEN) &&
                expected_TXINT === (expected_TXINT ^ TXINT ^ expected_TXINT) &&
                expected_TXOVRINT === (expected_TXOVRINT ^ TXOVRINT ^ expected_TXOVRINT) &&
                expected_UARTINT === (expected_UARTINT ^ UARTINT ^ expected_UARTINT)) begin
                $display("PASS");
                $display("  Outputs: BAUDTICK=%b, PRDATA=%h, PREADY=%b, PSLVERR=%b, RXINT=%b, RXOVRINT=%b, TXD=%b, TXEN=%b, TXINT=%b, TXOVRINT=%b, UARTINT=%b",
                         BAUDTICK, PRDATA, PREADY, PSLVERR, RXINT, RXOVRINT, TXD, TXEN, TXINT, TXOVRINT, UARTINT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BAUDTICK=%b, PRDATA=%h, PREADY=%b, PSLVERR=%b, RXINT=%b, RXOVRINT=%b, TXD=%b, TXEN=%b, TXINT=%b, TXOVRINT=%b, UARTINT=%b",
                         expected_BAUDTICK, expected_PRDATA, expected_PREADY, expected_PSLVERR, expected_RXINT, expected_RXOVRINT, expected_TXD, expected_TXEN, expected_TXINT, expected_TXOVRINT, expected_UARTINT);
                $display("  Got:      BAUDTICK=%b, PRDATA=%h, PREADY=%b, PSLVERR=%b, RXINT=%b, RXOVRINT=%b, TXD=%b, TXEN=%b, TXINT=%b, TXOVRINT=%b, UARTINT=%b",
                         BAUDTICK, PRDATA, PREADY, PSLVERR, RXINT, RXOVRINT, TXD, TXEN, TXINT, TXOVRINT, UARTINT);
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
