`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addra;
    reg clka;
    reg [31:0] dina;
    reg ena;
    reg wea;
    wire [31:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .ena(ena),
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
            ena = 0;
            wea = 0;
            addra = 0;
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
            ena = 1; wea = 1; addra = 7'd10; dina = 32'hA5A5A5A5;
            @(posedge clka);


            wea = 0; addra = 7'd10;
            @(posedge clka);
            #2;

            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 7'd0; dina = 32'h12345678;
            @(posedge clka);


            wea = 0; addra = 7'd0;
            @(posedge clka);
            #2;

            $display("Testcase 002: Boundary Address 0");
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 7'd127; dina = 32'hFEDCBA98;
            @(posedge clka);


            wea = 0; addra = 7'd127;
            @(posedge clka);
            #2;

            $display("Testcase 003: Boundary Address 127");
            #1;

            check_outputs(32'hFEDCBA98);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 7'd50; dina = 32'h11111111;
            @(posedge clka);


            dina = 32'h22222222;
            @(posedge clka);


            wea = 0; addra = 7'd50;
            @(posedge clka);
            #2;

            $display("Testcase 004: Data Overwrite");
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 7'd25; dina = 32'hBBBBBBBB;
            @(posedge clka);


            ena = 0; wea = 1; addra = 7'd25; dina = 32'hCCCCCCCC;
            @(posedge clka);


            ena = 1; wea = 0; addra = 7'd25;
            @(posedge clka);
            #2;

            $display("Testcase 005: Enable signal check (Write Protection)");
            #1;

            check_outputs(32'hBBBBBBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 7'd80; dina = 32'h55555555;
            @(posedge clka);


            wea = 0; addra = 7'd80; dina = 32'hFFFFFFFF;
            @(posedge clka);


            addra = 7'd80;
            @(posedge clka);
            #2;

            $display("Testcase 006: Write Enable logic check");
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_douta;
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
        $dumpvars(0,addra, clka, dina, ena, wea, douta);
    end

endmodule
