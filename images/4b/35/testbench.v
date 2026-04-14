`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
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
            addra = 14'b0;
            dina = 12'b0;
            @(negedge clka);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0x0000");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clka);
            wea = 1; addra = 14'h0000; dina = 12'hA5A;
            @(negedge clka);
            wea = 0;


            addra = 14'h0000;
            @(negedge clka);

            #1;


            check_outputs(12'hA5A);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Boundary Address - Write and Read at Max Address 0x3FFF");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clka);
            wea = 1; addra = 14'h3FFF; dina = 12'h5A5;
            @(negedge clka);
            wea = 0;


            addra = 14'h3FFF;
            @(negedge clka);

            #1;


            check_outputs(12'h5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting data at the same address");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clka);
            wea = 1; addra = 14'h1234; dina = 12'h111;
            @(negedge clka);


            wea = 1; addra = 14'h1234; dina = 12'h222;
            @(negedge clka);
            wea = 0;


            addra = 14'h1234;
            @(negedge clka);

            #1;


            check_outputs(12'h222);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Memory persistence and non-interference");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clka);
            wea = 1; addra = 14'h0100; dina = 12'hABC;
            @(negedge clka);


            wea = 1; addra = 14'h0200; dina = 12'hDEF;
            @(negedge clka);
            wea = 0;


            addra = 14'h0100;
            @(negedge clka);

            #1;


            check_outputs(12'hABC);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Read after write at various addresses");
            reset_dut();
            test_num = test_num + 1;


            @(negedge clka);
            wea = 1; addra = 14'h0001; dina = 12'hFFF;
            @(negedge clka);
            wea = 0;


            addra = 14'h0001;
            @(negedge clka);

            #1;


            check_outputs(12'hFFF);
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
        $dumpvars(0,addra, clka, dina, wea, douta);
    end

endmodule
