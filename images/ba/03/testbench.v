`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addra;
    reg clka;
    reg [7:0] dina;
    reg ena;
    reg wea;
    wire [7:0] douta;

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
            $display("Running testcase001: Basic Write and Read");
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 12'h010;
            dina = 8'hA5;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 12'h010;
            @(posedge clka);
            #1;


            #1;



            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Boundary Address 4095");
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 12'hFFF;
            dina = 8'h5A;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 12'hFFF;
            @(posedge clka);
            #1;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Chip Enable Logic Test");
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 12'h005;
            dina = 8'h11;
            @(posedge clka);
            #1;


            ena = 0;
            wea = 1;
            addra = 12'h005;
            dina = 8'h22;
            @(posedge clka);
            #1;


            ena = 1;
            wea = 0;
            addra = 12'h005;
            @(posedge clka);
            #1;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable Logic Test");
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 12'h020;
            dina = 8'hCC;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 12'h020;
            dina = 8'hDD;
            @(posedge clka);
            #1;


            addra = 12'h020;
            @(posedge clka);
            #1;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite Test");
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 12'h100;
            dina = 8'hAA;
            @(posedge clka);
            #1;


            dina = 8'h55;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Address Switching Test");
            reset_dut();


            ena = 1; wea = 1; addra = 12'h00A; dina = 8'h0A;
            @(posedge clka); #1;


            addra = 12'h00B; dina = 8'h0B;
            @(posedge clka); #1;


            wea = 0; addra = 12'h00A;
            @(posedge clka); #1;


            #1;



            check_outputs(8'h0A);
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
        input [7:0] expected_douta;
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
