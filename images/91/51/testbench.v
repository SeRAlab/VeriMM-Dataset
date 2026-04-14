`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] addra;
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
            addra = 0;
            dina = 0;
            wea = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read Address 0");
            reset_dut();


            addra = 11'h000;
            dina = 12'hA5A;
            wea = 1'b1;
            @(posedge clka);


            wea = 1'b0;
            @(posedge clka);

            #1;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Boundary Address 2047");
            reset_dut();


            addra = 11'h7FF;
            dina = 12'hFFF;
            wea = 1'b1;
            @(posedge clka);


            wea = 1'b0;
            @(posedge clka);

            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Check");
            reset_dut();


            addra = 11'd100;
            dina = 12'h123;
            wea = 1'b1;
            @(posedge clka);


            addra = 11'd100;
            dina = 12'h999;
            wea = 1'b0;
            @(posedge clka);


            @(posedge clka);

            #1;

            #1;


            check_outputs(12'h123);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overwrite Data");
            reset_dut();


            addra = 11'h050;
            dina = 12'hAAA;
            wea = 1'b1;
            @(posedge clka);


            dina = 12'hBBB;
            @(posedge clka);


            wea = 1'b0;
            @(posedge clka);

            #1;
            #1;

            check_outputs(12'hBBB);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multi-Address Persistence");
            reset_dut();


            addra = 11'd10; dina = 12'h010; wea = 1;
            @(posedge clka);

            addra = 11'd20; dina = 12'h020; wea = 1;
            @(posedge clka);


            wea = 0;
            addra = 11'd10;
            @(posedge clka);

            #1;
            #1;

            check_outputs(12'h010);
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
