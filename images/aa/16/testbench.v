`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addra;
    reg clka;
    reg [31:0] dina;
    reg [3:0] wea;
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
        wea = 4'b0000;
        addra = 8'h0;
        dina = 32'h0;
        @(posedge clka);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        addra = 8'h10;
        dina = 32'hA5A5_5A5A;
        wea = 4'hF;
        @(posedge clka);
        #1;

        wea = 4'h0;
        @(posedge clka);
        #5;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        addra = 8'h20;
        dina = 32'h0000_0000;
        wea = 4'hF;
        @(posedge clka);
        #1;

        dina = 32'hFFFF_FFBB;
        wea = 4'b0001;
        @(posedge clka);
        #1;
        wea = 4'h0;
        @(posedge clka);
        #5;
        #1;

        check_outputs(32'h0000_00BB);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        addra = 8'h30;
        dina = 32'h1111_1111;
        wea = 4'hF;
        @(posedge clka);
        #1;

        dina = 32'h00CC_DD00;
        wea = 4'b0110;
        @(posedge clka);
        #1;
        wea = 4'h0;
        @(posedge clka);
        #5;
        #1;

        check_outputs(32'h11CC_DD11);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        addra = 8'h40;
        dina = 32'h0000_0000;
        wea = 4'hF;
        @(posedge clka);
        #1;

        dina = 32'hEE00_0000;
        wea = 4'b1000;
        @(posedge clka);
        #1;
        wea = 4'h0;
        @(posedge clka);
        #5;
        #1;

        check_outputs(32'hEE00_0000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        addra = 8'hFF;
        dina = 32'hDEAD_BEEF;
        wea = 4'hF;
        @(posedge clka);
        #1;
        wea = 4'h0;
        @(posedge clka);
        #5;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        addra = 8'h55;
        dina = 32'hCAFE_BABE;
        wea = 4'hF;
        @(posedge clka);
        #1;

        dina = 32'h0000_0000;
        wea = 4'h0;
        @(posedge clka);
        #1;

        @(posedge clka);
        #5;
        #1;

        check_outputs(32'hCAFE_BABE);
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
        $dumpvars(0,addra, clka, dina, wea, douta);
    end

endmodule
