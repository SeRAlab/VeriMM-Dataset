`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
    reg [13:0] addrb;
    reg clka;
    reg clkb;
    reg [7:0] dina;
    reg [7:0] dinb;
    reg ena;
    reg wea;
    reg web;
    wire [7:0] douta;
    wire [7:0] doutb;

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
            addra = 14'd0;
            addrb = 14'd0;
            dina = 8'd0;
            dinb = 8'd0;
            wea = 1'b0;
            web = 1'b0;
            ena = 1'b0;
            repeat(2) @(posedge clka);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Port A Write/Read...");
            test_num = 1;
            reset_dut();


            @(posedge clka);
            ena = 1'b1;
            wea = 1'b1;
            addra = 14'h0100;
            dina = 8'hA5;


            @(posedge clka);
            wea = 1'b0;
            addra = 14'h0100;


            @(posedge clka);
            #1;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Port B Write/Read...");
            test_num = 2;
            reset_dut();


            @(posedge clkb);
            ena = 1'b1;
            web = 1'b1;
            addrb = 14'h0200;
            dinb = 8'h5A;


            @(posedge clkb);
            web = 1'b0;
            addrb = 14'h0200;


            @(posedge clkb);
            #1;
            #1;

            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simultaneous Port A and B Writes...");
            test_num = 3;
            reset_dut();


            @(posedge clka);
            ena = 1'b1;
            wea = 1'b1; addra = 14'h0010; dina = 8'h11;
            web = 1'b1; addrb = 14'h0020; dinb = 8'h22;


            @(posedge clka);
            wea = 1'b0; addra = 14'h0010;
            web = 1'b0; addrb = 14'h0020;


            @(posedge clka);
            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Port B Write then Port A Read...");
            test_num = 4;
            reset_dut();


            @(posedge clkb);
            ena = 1'b1;
            web = 1'b1; addrb = 14'h3FFF; dinb = 8'hEE;


            @(posedge clka);
            web = 1'b0;
            addra = 14'h3FFF;

            @(posedge clka);
            #1;
            #1;

            check_outputs(8'hEE, 8'hEE);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Enable (ena) Signal Check...");
            test_num = 5;
            reset_dut();


            @(posedge clka);
            ena = 1'b1;
            wea = 1'b1; addra = 14'h0005; dina = 8'h99;


            @(posedge clka);
            wea = 1'b0;
            ena = 1'b0;
            addra = 14'h0005;

            @(posedge clka);
            #1;

            if (douta !== 8'h99) begin


                #1;



                check_outputs(8'h00, 8'h00);
            end else begin

                $display("FAIL: Data read while ena was low");
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_douta;
        input [7:0] expected_doutb;
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
        $dumpvars(0,addra, addrb, clka, clkb, dina, dinb, ena, wea, web, douta, doutb);
    end

endmodule
