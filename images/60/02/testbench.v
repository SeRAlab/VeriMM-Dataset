`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addra;
    reg clka;
    reg [71:0] dina;
    reg wea;
    wire [71:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .wea(wea),
        .douta(douta)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            wea = 0;
            addra = 0;
            dina = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            addra = 8'h05;
            dina = 72'hA5A5A5A5_5A5A5A5A_FF;
            wea = 1;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 8'h05;
            @(posedge clka);
            #1;

            $display("Testcase 001: Basic Write/Read Address 0x05");
            #1;

            check_outputs(72'hA5A5A5A5_5A5A5A5A_FF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            addra = 8'hFF;
            dina = 72'hFFFFFFFF_FFFFFFFF_FF;
            wea = 1;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 8'hFF;
            @(posedge clka);
            #1;

            $display("Testcase 002: Boundary Write/Read Address 0xFF");
            #1;

            check_outputs(72'hFFFFFFFF_FFFFFFFF_FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            addra = 8'h20;
            dina = 72'h11223344_55667788_99;
            wea = 1;
            @(posedge clka);
            #1;


            dina = 72'h99887766_55443322_11;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 8'h20;
            @(posedge clka);
            #1;

            $display("Testcase 003: Overwrite Address 0x20");
            #1;

            check_outputs(72'h99887766_55443322_11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            addra = 8'h10;
            dina = 72'hDEADC0DE_FEEDFACE_01;
            wea = 1;
            @(posedge clka);
            #1;


            addra = 8'h11;
            dina = 72'hBEEFCAFE_ABADBABE_02;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 8'h10;
            @(posedge clka);
            #1;

            $display("Testcase 004: Sequential Write Check (Read 0x10)");
            #1;

            check_outputs(72'hDEADC0DE_FEEDFACE_01);
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
        input [71:0] expected_douta;
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
        $dumpvars(0,addra, clka, dina, wea, douta);
    end

endmodule
