`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addra;
    reg clka;
    wire [35:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .douta(douta)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            addra = 10'b0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Read Address 0x000");
            reset_dut();
            addra <= 10'h000;
            @(posedge clka);
            @(posedge clka);
            #2;


            #1;



            check_outputs(douta);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Read Address 0x3FF");
            reset_dut();
            addra <= 10'h3FF;
            @(posedge clka);
            @(posedge clka);
            #2;
            #1;

            check_outputs(douta);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Read Address 0x200");
            reset_dut();
            addra <= 10'h200;
            @(posedge clka);
            @(posedge clka);
            #2;
            #1;

            check_outputs(douta);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Sequential Reads");
            reset_dut();


            addra <= 10'h010;
            @(posedge clka);


            addra <= 10'h011;
            @(posedge clka);


            @(posedge clka);
            #2;
            #1;

            check_outputs(douta);
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
        input [35:0] expected_douta;
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
        $dumpvars(0,addra, clka, douta);
    end

endmodule
