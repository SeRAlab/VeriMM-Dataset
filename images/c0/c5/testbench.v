`timescale 1ns/1ps

module omsp_watchdog_tb;

    // Testbench signals (sequential circuit)
    reg aclk_en;
    reg dbg_freeze;
    reg mclk;
    reg nmi;
    reg nmie;
    reg [7:0] per_addr;
    reg [15:0] per_din;
    reg per_en;
    reg [1:0] per_wen;
    reg puc;
    reg smclk_en;
    reg wdtie;
    wire nmi_evt;
    wire [15:0] per_dout;
    wire wdtifg_set;
    wire wdtpw_error;
    wire wdttmsel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    omsp_watchdog dut (
        .aclk_en(aclk_en),
        .dbg_freeze(dbg_freeze),
        .mclk(mclk),
        .nmi(nmi),
        .nmie(nmie),
        .per_addr(per_addr),
        .per_din(per_din),
        .per_en(per_en),
        .per_wen(per_wen),
        .puc(puc),
        .smclk_en(smclk_en),
        .wdtie(wdtie),
        .nmi_evt(nmi_evt),
        .per_dout(per_dout),
        .wdtifg_set(wdtifg_set),
        .wdtpw_error(wdtpw_error),
        .wdttmsel(wdttmsel)
    );

    // Clock generation (10ns period)
    initial begin
        mclk = 0;
        forever #5 mclk = ~mclk;
    end

        task reset_dut;

        begin
            aclk_en    = 0;
            dbg_freeze = 0;
            nmi        = 1;
            nmie       = 0;
            per_addr   = 8'h00;
            per_din    = 16'h0000;
            per_en     = 0;
            per_wen    = 2'b00;
            puc        = 1;
            smclk_en   = 0;
            wdtie      = 0;
            #20;
            puc        = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset and Default State", test_num);
            reset_dut();
            @(posedge mclk);


            per_addr = 8'h20;
            per_en   = 1;
            per_wen  = 2'b00;
            @(posedge mclk);
            #1;
            #1;

            check_outputs(0, 16'h6900, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Password Error Detection", test_num);
            reset_dut();
            @(posedge mclk);
            per_addr = 8'h20;
            per_en   = 1;
            per_wen  = 2'b11;
            per_din  = 16'h0000;
            @(posedge mclk);
            #1;

            #1;


            check_outputs(0, 16'h6900, 0, 1, 0);
            per_en   = 0;
            per_wen  = 0;
            @(posedge mclk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Interval Timer Mode Selection", test_num);
            reset_dut();
            @(posedge mclk);
            per_addr = 8'h20;
            per_en   = 1;
            per_wen  = 2'b11;

            per_din  = 16'h5A10;
            @(posedge mclk);
            #1;
            per_en   = 0;
            per_wen  = 0;
            @(posedge mclk);

            #1;


            check_outputs(0, 16'h6910, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Debug Freeze Operation", test_num);
            reset_dut();
            @(posedge mclk);

            per_addr = 8'h20;
            per_en   = 1;
            per_wen  = 2'b11;
            per_din  = 16'h5A13;
            @(posedge mclk);
            per_en   = 0;


            dbg_freeze = 1;
            smclk_en   = 1;


            repeat(100) @(posedge mclk);
            #1;
            #1;

            check_outputs(0, 16'h6913, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: NMI Event Triggering", test_num);
            reset_dut();
            @(posedge mclk);

            per_addr = 8'h20;
            per_en   = 1;
            per_wen  = 2'b11;
            per_din  = 16'h5A60;
            nmie     = 1;
            @(posedge mclk);
            per_en   = 0;


            nmi = 1;
            @(posedge mclk);
            nmi = 0;
            @(posedge mclk);
            @(posedge mclk);
            #1;

            #1;


            check_outputs(1, 16'h6960, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("omsp_watchdog Testbench");
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
        input expected_nmi_evt;
        input [15:0] expected_per_dout;
        input expected_wdtifg_set;
        input expected_wdtpw_error;
        input expected_wdttmsel;
        begin
            if (expected_nmi_evt === (expected_nmi_evt ^ nmi_evt ^ expected_nmi_evt) &&
                expected_per_dout === (expected_per_dout ^ per_dout ^ expected_per_dout) &&
                expected_wdtifg_set === (expected_wdtifg_set ^ wdtifg_set ^ expected_wdtifg_set) &&
                expected_wdtpw_error === (expected_wdtpw_error ^ wdtpw_error ^ expected_wdtpw_error) &&
                expected_wdttmsel === (expected_wdttmsel ^ wdttmsel ^ expected_wdttmsel)) begin
                $display("PASS");
                $display("  Outputs: nmi_evt=%b, per_dout=%h, wdtifg_set=%b, wdtpw_error=%b, wdttmsel=%b",
                         nmi_evt, per_dout, wdtifg_set, wdtpw_error, wdttmsel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nmi_evt=%b, per_dout=%h, wdtifg_set=%b, wdtpw_error=%b, wdttmsel=%b",
                         expected_nmi_evt, expected_per_dout, expected_wdtifg_set, expected_wdtpw_error, expected_wdttmsel);
                $display("  Got:      nmi_evt=%b, per_dout=%h, wdtifg_set=%b, wdtpw_error=%b, wdttmsel=%b",
                         nmi_evt, per_dout, wdtifg_set, wdtpw_error, wdttmsel);
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
        $dumpvars(0,aclk_en, dbg_freeze, mclk, nmi, nmie, per_addr, per_din, per_en, per_wen, puc, smclk_en, wdtie, nmi_evt, per_dout, wdtifg_set, wdtpw_error, wdttmsel);
    end

endmodule
