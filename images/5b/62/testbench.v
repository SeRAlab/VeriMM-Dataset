`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addra_i;
    reg [3:0] addrb_i;
    reg cena_i;
    reg cenb_i;
    reg clka;
    reg clkb;
    reg [127:0] dataa_i;
    reg [127:0] datab_i;
    reg rena_i;
    reg renb_i;
    reg wena_i;
    reg wenb_i;
    wire [127:0] dataa_o;
    wire [127:0] datab_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra_i(addra_i),
        .addrb_i(addrb_i),
        .cena_i(cena_i),
        .cenb_i(cenb_i),
        .clka(clka),
        .clkb(clkb),
        .dataa_i(dataa_i),
        .datab_i(datab_i),
        .rena_i(rena_i),
        .renb_i(renb_i),
        .wena_i(wena_i),
        .wenb_i(wenb_i),
        .dataa_o(dataa_o),
        .datab_o(datab_o)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

    begin
        cena_i = 0; cenb_i = 0;
        rena_i = 0; renb_i = 0;
        wena_i = 0; wenb_i = 0;
        addra_i = 0; addrb_i = 0;
        dataa_i = 0; datab_i = 0;
        repeat(2) @(posedge clka);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Port A Write and Read...");


        @(posedge clka);
        cena_i = 1; wena_i = 1; addra_i = 4'h4; dataa_i = 128'hDEADBEEF_CAFE_BABE_0123_456789ABCDEF;
        @(posedge clka);
        wena_i = 0; cena_i = 0;


        @(posedge clka);
        cena_i = 1; rena_i = 1; addra_i = 4'h4;
        @(posedge clka);
        rena_i = 0; cena_i = 0;
        #1;
        #1;

        check_outputs(128'hDEADBEEF_CAFE_BABE_0123_456789ABCDEF, 128'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Port B Write and Read...");


        @(posedge clkb);
        cenb_i = 1; wenb_i = 1; addrb_i = 4'hA; datab_i = 128'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111;
        @(posedge clkb);
        wenb_i = 0; cenb_i = 0;


        @(posedge clkb);
        cenb_i = 1; renb_i = 1; addrb_i = 4'hA;
        @(posedge clkb);
        renb_i = 0; cenb_i = 0;
        #1;
        #1;

        check_outputs(128'h0, 128'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Simultaneous Port A and Port B Operations...");


        @(posedge clka);
        cena_i = 1; wena_i = 1; addra_i = 4'h1; dataa_i = 128'h1;
        cenb_i = 1; wenb_i = 1; addrb_i = 4'h2; datab_i = 128'h2;

        @(posedge clka);

        wena_i = 0; rena_i = 1; addra_i = 4'h1;
        wenb_i = 0; renb_i = 1; addrb_i = 4'h2;

        @(posedge clka);
        rena_i = 0; renb_i = 0;
        cena_i = 0; cenb_i = 0;
        #1;
        #1;

        check_outputs(128'h1, 128'h2);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Cross-Port Communication (Write A, Read B)...");


        @(posedge clka);
        cena_i = 1; wena_i = 1; addra_i = 4'hF; dataa_i = 128'hABC_123;
        @(posedge clka);
        wena_i = 0; cena_i = 0;


        @(posedge clkb);
        cenb_i = 1; renb_i = 1; addrb_i = 4'hF;
        @(posedge clkb);
        renb_i = 0; cenb_i = 0;
        #1;
        #1;

        check_outputs(128'h0, 128'hABC_123);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Verify Chip Enable inhibits operations...");


        @(posedge clka);
        cena_i = 0; wena_i = 1; addra_i = 4'h5; dataa_i = 128'hFF;
        @(posedge clka);


        cena_i = 1; rena_i = 1; addra_i = 4'h5;
        @(posedge clka);
        rena_i = 0; cena_i = 0;
        #1;
        #1;

        check_outputs(128'h0, 128'h0);
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
        input [127:0] expected_dataa_o;
        input [127:0] expected_datab_o;
        begin
            if (expected_dataa_o === (expected_dataa_o ^ dataa_o ^ expected_dataa_o) &&
                expected_datab_o === (expected_datab_o ^ datab_o ^ expected_datab_o)) begin
                $display("PASS");
                $display("  Outputs: dataa_o=%h, datab_o=%h",
                         dataa_o, datab_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataa_o=%h, datab_o=%h",
                         expected_dataa_o, expected_datab_o);
                $display("  Got:      dataa_o=%h, datab_o=%h",
                         dataa_o, datab_o);
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
        $dumpvars(0,addra_i, addrb_i, cena_i, cenb_i, clka, clkb, dataa_i, datab_i, rena_i, renb_i, wena_i, wenb_i, dataa_o, datab_o);
    end

endmodule
