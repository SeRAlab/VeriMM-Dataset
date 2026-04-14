`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addra;
    reg clka;
    reg [11:0] dina;
    reg wea;
    wire [11:0] douta;

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
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            @(posedge clka);
            wea = 1;
            addra = 13'h0000;
            dina = 12'hA5A;

            @(posedge clka);
            wea = 0;
            #2;

            #1;


            check_outputs(12'hA5A);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read at High Address (13'h1FFF)");
            reset_dut();

            @(posedge clka);
            wea = 1;
            addra = 13'h1FFF;
            dina = 12'h5A5;

            @(posedge clka);
            wea = 0;
            #2;

            #1;


            check_outputs(12'h5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify wea=0 prevents writing");
            reset_dut();


            @(posedge clka);
            wea = 0;
            addra = 13'h0010;
            dina = 12'hFFF;

            @(posedge clka);
            #2;


            #1;



            check_outputs(12'h000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwrite existing memory address");
            reset_dut();


            @(posedge clka);
            wea = 1;
            addra = 13'h0020;
            dina = 12'h123;


            @(posedge clka);
            wea = 1;
            addra = 13'h0020;
            dina = 12'h456;

            @(posedge clka);
            wea = 0;
            #2;

            #1;


            check_outputs(12'h456);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous Read and Write at same address");
            reset_dut();



            @(posedge clka);
            wea = 1;
            addra = 13'h0050;
            dina = 12'hFED;

            #2;


            #1;



            check_outputs(12'hFED);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sequential writes to multiple addresses");
            reset_dut();

            @(posedge clka);
            wea = 1; addra = 13'h001; dina = 12'h001;
            @(posedge clka);
            wea = 1; addra = 13'h002; dina = 12'h002;
            @(posedge clka);
            wea = 1; addra = 13'h003; dina = 12'h003;

            @(posedge clka);
            wea = 0; addra = 13'h002;
            #2;

            #1;


            check_outputs(12'h002);
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
        $dumpvars(0,addra, clka, dina, wea, douta);
    end

endmodule
