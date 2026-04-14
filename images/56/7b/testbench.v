`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
    reg [13:0] addrb;
    reg clka;
    reg clkb;
    reg [7:0] dina;
    reg ena;
    reg enb;
    reg wea;
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
        .ena(ena),
        .enb(enb),
        .wea(wea),
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
            addra = 0;
            addrb = 0;
            dina = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h005; dina = 8'hAA;
            @(posedge clka);
            wea = 0; ena = 0;


            @(posedge clka);
            ena = 1; addra = 14'h005;
            @(posedge clka);
            #1;
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h123; dina = 8'h55;
            @(posedge clka);
            wea = 0; ena = 0;


            @(posedge clkb);
            enb = 1; addrb = 14'h123;
            @(posedge clkb);
            #1;
            #1;

            check_outputs(8'h00, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clka);
            ena = 0; wea = 1; addra = 14'h010; dina = 8'hFF;
            @(posedge clka);


            @(posedge clka);
            ena = 1; wea = 0; addra = 14'h010;
            @(posedge clka);
            #1;
            if (douta !== 8'hFF) begin
                $display("PASS: Write correctly inhibited by ena=0");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Write occurred despite ena=0");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 14'h001; dina = 8'h11;
            @(posedge clka);
            addra = 14'h002; dina = 8'h22;
            @(posedge clka);
            wea = 0; ena = 0;


            @(posedge clka);
            ena = 1; addra = 14'h001;
            enb = 1; addrb = 14'h002;
            @(posedge clka);
            #1;
            #1;

            check_outputs(8'h11, 8'h22);
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
        $dumpvars(0,addra, addrb, clka, clkb, dina, ena, enb, wea, douta, doutb);
    end

endmodule
