`timescale 1ns/1ps

module omsp_sfr_tb;

    // Testbench signals (sequential circuit)
    reg mclk;
    reg nmi_acc;
    reg [7:0] per_addr;
    reg [15:0] per_din;
    reg per_en;
    reg [1:0] per_wen;
    reg por;
    reg puc;
    reg wdtifg_clr;
    reg wdtifg_set;
    reg wdtpw_error;
    reg wdttmsel;
    wire nmie;
    wire [15:0] per_dout;
    wire wdt_irq;
    wire wdt_reset;
    wire wdtie;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    omsp_sfr dut (
        .mclk(mclk),
        .nmi_acc(nmi_acc),
        .per_addr(per_addr),
        .per_din(per_din),
        .per_en(per_en),
        .per_wen(per_wen),
        .por(por),
        .puc(puc),
        .wdtifg_clr(wdtifg_clr),
        .wdtifg_set(wdtifg_set),
        .wdtpw_error(wdtpw_error),
        .wdttmsel(wdttmsel),
        .nmie(nmie),
        .per_dout(per_dout),
        .wdt_irq(wdt_irq),
        .wdt_reset(wdt_reset),
        .wdtie(wdtie)
    );

    // Clock generation (10ns period)
    initial begin
        mclk = 0;
        forever #5 mclk = ~mclk;
    end

        task reset_dut;

        begin
            por = 1;
            puc = 1;
            nmi_acc = 0;
            per_addr = 0;
            per_din = 0;
            per_en = 0;
            per_wen = 0;
            wdtifg_clr = 0;
            wdtifg_set = 0;
            wdtpw_error = 0;
            wdttmsel = 0;
            @(posedge mclk);
            #1;
            por = 0;
            puc = 0;
            @(posedge mclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            per_addr = 8'h00;
            per_en = 1;
            per_wen = 2'b00;
            @(posedge mclk);
            #1;

            check_outputs(1'b0, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge mclk);
            per_addr = 8'h00;
            per_din  = 16'h0011;
            per_en   = 1;
            per_wen  = 2'b11;
            @(posedge mclk);
            per_wen  = 2'b00;
            @(posedge mclk);

            #1;


            check_outputs(1'b1, 16'h0011, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            per_addr = 8'h00;
            per_din  = 16'h0001;
            per_en   = 1;
            per_wen  = 2'b11;
            wdttmsel = 1;
            @(posedge mclk);
            per_wen  = 2'b00;

            wdtifg_set = 1;
            @(posedge mclk);
            wdtifg_set = 0;
            @(posedge mclk);


            per_addr = 8'h02;
            @(posedge mclk);
            #1;

            check_outputs(1'b0, 16'h0001, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            wdttmsel = 0;
            wdtifg_set = 1;
            @(posedge mclk);
            wdtifg_set = 0;
            @(posedge mclk);

            #1;


            check_outputs(1'b0, 16'h0000, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            wdtpw_error = 1;
            @(posedge mclk);
            wdtpw_error = 0;
            @(posedge mclk);

            #1;


            check_outputs(1'b0, 16'h0000, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            per_addr = 8'h02;
            per_din  = 16'h0010;
            per_en   = 1;
            per_wen  = 2'b11;
            @(posedge mclk);
            per_wen = 2'b00;
            @(posedge mclk);


            nmi_acc = 1;
            @(posedge mclk);
            nmi_acc = 0;
            @(posedge mclk);

            #1;


            check_outputs(1'b0, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            wdtifg_set = 1;
            @(posedge mclk);
            wdtifg_set = 0;

            wdtifg_clr = 1;
            @(posedge mclk);
            wdtifg_clr = 0;
            per_addr = 8'h02;
            per_en = 1;
            @(posedge mclk);
            #1;

            check_outputs(1'b0, 16'h0000, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("omsp_sfr Testbench");
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
        input expected_nmie;
        input [15:0] expected_per_dout;
        input expected_wdt_irq;
        input expected_wdt_reset;
        input expected_wdtie;
        begin
            if (expected_nmie === (expected_nmie ^ nmie ^ expected_nmie) &&
                expected_per_dout === (expected_per_dout ^ per_dout ^ expected_per_dout) &&
                expected_wdt_irq === (expected_wdt_irq ^ wdt_irq ^ expected_wdt_irq) &&
                expected_wdt_reset === (expected_wdt_reset ^ wdt_reset ^ expected_wdt_reset) &&
                expected_wdtie === (expected_wdtie ^ wdtie ^ expected_wdtie)) begin
                $display("PASS");
                $display("  Outputs: nmie=%b, per_dout=%h, wdt_irq=%b, wdt_reset=%b, wdtie=%b",
                         nmie, per_dout, wdt_irq, wdt_reset, wdtie);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nmie=%b, per_dout=%h, wdt_irq=%b, wdt_reset=%b, wdtie=%b",
                         expected_nmie, expected_per_dout, expected_wdt_irq, expected_wdt_reset, expected_wdtie);
                $display("  Got:      nmie=%b, per_dout=%h, wdt_irq=%b, wdt_reset=%b, wdtie=%b",
                         nmie, per_dout, wdt_irq, wdt_reset, wdtie);
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
        $dumpvars(0,mclk, nmi_acc, per_addr, per_din, per_en, per_wen, por, puc, wdtifg_clr, wdtifg_set, wdtpw_error, wdttmsel, nmie, per_dout, wdt_irq, wdt_reset, wdtie);
    end

endmodule
