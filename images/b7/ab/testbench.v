`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
    reg [13:0] addrb;
    reg clka;
    reg clkb;
    reg [15:0] dina;
    reg [15:0] dinb;
    reg ena;
    reg enb;
    reg wea;
    reg web;
    wire [15:0] douta;
    wire [15:0] doutb;

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
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read Port A", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h0005; dina = 16'hABCD;
            @(posedge clka);
            wea = 0;


            addra = 14'h0005;
            @(posedge clka);
            @(posedge clka);
            #1;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read Port B", test_num);
            reset_dut();


            @(posedge clkb);
            enb = 1; web = 1; addrb = 14'h0010; dinb = 16'h55AA;
            @(posedge clkb);
            web = 0;


            addrb = 14'h0010;
            @(posedge clkb);
            @(posedge clkb);
            #1;
            #1;

            check_outputs(16'h0000, 16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Dual Port Writes", test_num);
            reset_dut();


            fork
                begin
                    @(posedge clka);
                    ena = 1; wea = 1; addra = 14'h0100; dina = 16'h1111;
                    @(posedge clka); wea = 0;
                end
                begin
                    @(posedge clkb);
                    enb = 1; web = 1; addrb = 14'h0200; dinb = 16'h2222;
                    @(posedge clkb); web = 0;
                end
            join


            addra = 14'h0100;
            addrb = 14'h0200;
            repeat(2) @(posedge clka);
            #1;
            #1;

            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Port A Write and Port B Read same address", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h0050; dina = 16'hDEAD;
            @(posedge clka); wea = 0;


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h0050; dina = 16'hBEEF;
            enb = 1; web = 0; addrb = 14'h0050;

            repeat(2) @(posedge clka);
            #1;



            #1;




            check_outputs(16'hBEEF, 16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Testing Enable Signals (ena=0)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 0; wea = 1; addra = 14'h0070; dina = 16'hCAFE;
            @(posedge clka);


            ena = 1; wea = 0; addra = 14'h0070;
            repeat(2) @(posedge clka);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Testing Write Enable (wea=0)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 0; addra = 14'h0080; dina = 16'hF00D;
            @(posedge clka);


            addra = 14'h0080;
            repeat(2) @(posedge clka);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Boundary Address Check (16383)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h3FFF; dina = 16'hFFFF;
            @(posedge clka);
            wea = 0;


            addra = 14'h3FFF;
            repeat(2) @(posedge clka);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
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
        input [15:0] expected_douta;
        input [15:0] expected_doutb;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta) &&
                expected_doutb === (expected_doutb ^ doutb ^ expected_doutb)) begin
                $display("PASS");
                $display("  Outputs: douta=%h, doutb=%h",
                         douta, doutb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h, doutb=%h",
                         expected_douta, expected_doutb);
                $display("  Got:      douta=%h, doutb=%h",
                         douta, doutb);
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
        $dumpvars(0,addra, addrb, clka, clkb, dina, dinb, ena, enb, wea, web, douta, doutb);
    end

endmodule
