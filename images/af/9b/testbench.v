`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addra;
    reg [31:0] addrb;
    reg clka;
    reg clkb;
    reg [31:0] dina;
    reg [31:0] dinb;
    reg ena;
    reg enb;
    reg wea;
    reg web;
    wire acka;
    wire ackb;
    wire [31:0] douta;
    wire [31:0] doutb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .dinb(dinb),
        .ena(ena),
        .enb(enb),
        .wea(wea),
        .web(web),
        .acka(acka),
        .ackb(ackb),
        .douta(douta),
        .doutb(doutb)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            ena = 0;
            enb = 0;
            wea = 0;
            web = 0;
            addra = 0;
            addrb = 0;
            dina = 0;
            dinb = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Port A Basic Write/Read");
            reset_dut();
            @(negedge clka);
            ena = 1; wea = 1; addra = 32'h0000_0010; dina = 32'hDEAD_BEEF;
            @(posedge clka);
            @(negedge clka);
            wea = 0;
            @(posedge clka);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 32'hDEAD_BEEF, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Port B Basic Write/Read");
            reset_dut();
            @(negedge clkb);
            enb = 1; web = 1; addrb = 32'h0000_0020; dinb = 32'hCAFE_BABE;
            @(posedge clkb);
            @(negedge clkb);
            web = 0;
            @(posedge clkb);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 32'h0, 32'hCAFE_BABE);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simultaneous Port A Write / Port B Read");
            reset_dut();

            @(negedge clka);
            ena = 1; wea = 1; addra = 32'h30; dina = 32'h1111_2222;
            @(posedge clka);
            @(negedge clka);
            ena = 0; wea = 0;


            fork
                begin
                    @(negedge clka);
                    ena = 1; wea = 1; addra = 32'h40; dina = 32'hAAAA_AAAA;
                    @(posedge clka);
                    ena = 1; wea = 0;
                    @(posedge clka);
                end
                begin
                    @(negedge clkb);
                    enb = 1; web = 0; addrb = 32'h30;
                    @(posedge clkb);
                    @(posedge clkb);
                end
            join
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 32'hAAAA_AAAA, 32'h1111_2222);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Cross-port Verification");
            reset_dut();

            @(negedge clka);
            ena = 1; wea = 1; addra = 32'h100; dina = 32'h5555_6666;
            @(posedge clka);
            ena = 0;

            @(negedge clkb);
            enb = 1; web = 0; addrb = 32'h100;
            @(posedge clkb);
            #2;
            #1;

            check_outputs(1'b0, 1'b1, 32'h0, 32'h5555_6666);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable signal logic check");
            reset_dut();

            @(negedge clka);
            ena = 1; wea = 1; addra = 32'h5; dina = 32'h0000_8888;
            @(posedge clka);

            @(negedge clka);
            ena = 0; wea = 1; addra = 32'h5; dina = 32'h0000_9999;
            @(posedge clka);

            @(negedge clka);
            ena = 1; wea = 0; addra = 32'h5;
            @(posedge clka);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 32'h0000_8888, 32'h0);
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
        input expected_acka;
        input expected_ackb;
        input [31:0] expected_douta;
        input [31:0] expected_doutb;
        begin
            if (expected_acka === (expected_acka ^ acka ^ expected_acka) &&
                expected_ackb === (expected_ackb ^ ackb ^ expected_ackb) &&
                expected_douta === (expected_douta ^ douta ^ expected_douta) &&
                expected_doutb === (expected_doutb ^ doutb ^ expected_doutb)) begin
                $display("PASS");
                $display("  Outputs: acka=%b, ackb=%b, douta=%h, doutb=%h",
                         acka, ackb, douta, doutb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acka=%b, ackb=%b, douta=%h, doutb=%h",
                         expected_acka, expected_ackb, expected_douta, expected_doutb);
                $display("  Got:      acka=%b, ackb=%b, douta=%h, doutb=%h",
                         acka, ackb, douta, doutb);
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
        $dumpvars(0,addra, addrb, clka, clkb, dina, dinb, ena, enb, wea, web, acka, ackb, douta, doutb);
    end

endmodule
