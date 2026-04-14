`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addra;
    reg clka;
    reg [15:0] dina;
    reg ena;
    reg [1:0] wea;
    wire [15:0] douta;

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
        wea = 2'b00;
        addra = 10'b0;
        dina = 16'b0;
        @(posedge clka);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Full Word Write/Read", test_num);
        reset_dut();


        ena = 1;
        wea = 2'b11;
        addra = 10'h010;
        dina = 16'hABCD;
        @(posedge clka);
        #1;


        wea = 2'b00;
        addra = 10'h010;
        @(posedge clka);
        #1;

        #1;


        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Lower Byte Write", test_num);
        reset_dut();


        ena = 1;
        wea = 2'b11;
        addra = 10'h020;
        dina = 16'h0000;
        @(posedge clka);
        #1;


        wea = 2'b01;
        dina = 16'hFFAA;
        @(posedge clka);
        #1;


        wea = 2'b00;
        @(posedge clka);
        #1;

        #1;


        check_outputs(16'h00AA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Upper Byte Write", test_num);
        reset_dut();


        ena = 1;
        wea = 2'b11;
        addra = 10'h030;
        dina = 16'h0000;
        @(posedge clka);
        #1;


        wea = 2'b10;
        dina = 16'hBBFF;
        @(posedge clka);
        #1;


        wea = 2'b00;
        @(posedge clka);
        #1;

        #1;


        check_outputs(16'hBB00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enable (ena) Inactive Check", test_num);
        reset_dut();


        ena = 1;
        wea = 2'b11;
        addra = 10'h040;
        dina = 16'h1111;
        @(posedge clka);
        #1;


        ena = 0;
        wea = 2'b11;
        dina = 16'hEEEE;
        @(posedge clka);
        #1;


        ena = 1;
        wea = 2'b00;
        @(posedge clka);
        #1;

        #1;


        check_outputs(16'h1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Max Address Boundary Check", test_num);
        reset_dut();


        ena = 1;
        wea = 2'b11;
        addra = 10'd1023;
        dina = 16'hF0F0;
        @(posedge clka);
        #1;


        wea = 2'b00;
        @(posedge clka);
        #1;

        #1;


        check_outputs(16'hF0F0);
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
        input [15:0] expected_douta;
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
