`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addra;
    reg [11:0] addrb;
    reg clka;
    reg [11:0] dina;
    reg [11:0] dinb;
    reg wea;
    reg web;
    wire [11:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .addrb(addrb),
        .clka(clka),
        .dina(dina),
        .dinb(dinb),
        .wea(wea),
        .web(web),
        .douta(douta)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            addra = 0;
            addrb = 0;
            dina = 0;
            dinb = 0;
            wea = 0;
            web = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clka);
            wea = 1;
            addra = 12'h001;
            dina = 12'hABC;
            @(posedge clka);
            wea = 0;
            addra = 12'h001;
            @(posedge clka);
            #1;
            $display("Testcase 001: Basic Port A Write/Read");
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clka);
            web = 1;
            addrb = 12'h002;
            dinb = 12'h555;
            @(posedge clka);
            web = 0;
            addra = 12'h002;
            @(posedge clka);
            #1;
            $display("Testcase 002: Port B Write, Port A Read");
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clka);
            wea = 1;
            web = 1;
            addra = 12'h010;
            addrb = 12'h011;
            dina = 12'hAAA;
            dinb = 12'hBBB;
            @(posedge clka);
            wea = 0;
            web = 0;
            addra = 12'h011;
            @(posedge clka);
            #1;
            $display("Testcase 003: Simultaneous Writes (Checking Port B write via Port A read)");
            #1;

            check_outputs(12'hBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clka);
            addra = 12'hFFF;
            @(posedge clka);
            #1;
            $display("Testcase 004: Out-of-bounds address check");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge clka);
            wea = 1;
            addra = 12'h020;
            dina = 12'h123;
            @(posedge clka);

            dina = 12'h789;
            @(posedge clka);
            wea = 0;
            addra = 12'h020;
            @(posedge clka);
            #1;
            $display("Testcase 005: Overwrite check");
            #1;

            check_outputs(12'h789);
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
        input [11:0] expected_douta;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta)) begin
                $display("PASS");
                $display("  Outputs: douta=%h",
                         douta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h",
                         expected_douta);
                $display("  Got:      douta=%h",
                         douta);
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
        $dumpvars(0,addra, addrb, clka, dina, dinb, wea, web, douta);
    end

endmodule
