`timescale 1ns/1ps

module aeMB2_dparam_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] adr_i;
    reg clk_i;
    reg [1:0] dat_i;
    reg ena_i;
    reg wre_i;
    reg [4:0] xadr_i;
    reg [1:0] xdat_i;
    reg xwre_i;
    wire [1:0] dat_o;
    wire [1:0] xdat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_dparam dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .ena_i(ena_i),
        .wre_i(wre_i),
        .xadr_i(xadr_i),
        .xdat_i(xdat_i),
        .xwre_i(xwre_i),
        .dat_o(dat_o),
        .xdat_o(xdat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            ena_i = 0;
            wre_i = 0;
            xwre_i = 0;
            adr_i = 0;
            xadr_i = 0;
            dat_i = 0;
            xdat_i = 0;
            @(posedge clk_i);
            #1;
            ena_i = 1;
            $display("DUT Reset/Initialized");
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Port A Write and Read");
            reset_dut();

            adr_i = 5'h0A;
            dat_i = 2'b11;
            wre_i = 1;
            @(posedge clk_i);
            #1;
            wre_i = 0;


            xadr_i = 5'h00;


            #1;



            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Port B Write and Read");
            reset_dut();

            xadr_i = 5'h1F;
            xdat_i = 2'b10;
            xwre_i = 1;
            @(posedge clk_i);
            #1;
            xwre_i = 0;


            adr_i = 5'h00;


            #1;



            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Write Port A, Read from Port B");
            reset_dut();


            adr_i = 5'h05;
            dat_i = 2'b01;
            wre_i = 1;
            @(posedge clk_i);
            #1;
            wre_i = 0;


            xadr_i = 5'h05;
            adr_i = 5'h00;

            #1;

            #1;


            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Simultaneous Write to different addresses");
            reset_dut();


            adr_i = 5'd2;
            dat_i = 2'b11;
            wre_i = 1;

            xadr_i = 5'd3;
            xdat_i = 2'b10;
            xwre_i = 1;

            @(posedge clk_i);
            #1;
            wre_i = 0;
            xwre_i = 0;


            #1;



            check_outputs(2'b11, 2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Verify ena_i inhibits writes");
            reset_dut();

            ena_i = 0;
            adr_i = 5'h08;
            dat_i = 2'b11;
            wre_i = 1;

            @(posedge clk_i);
            #1;
            wre_i = 0;
            ena_i = 1;


            adr_i = 5'h08;
            #1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Port A overwrite existing data");
            reset_dut();


            adr_i = 5'h12;
            dat_i = 2'b11;
            wre_i = 1;
            @(posedge clk_i);
            #1;


            dat_i = 2'b01;
            @(posedge clk_i);
            #1;
            wre_i = 0;

            #1;


            check_outputs(2'b01, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_dparam Testbench");
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
        input [1:0] expected_dat_o;
        input [1:0] expected_xdat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_xdat_o === (expected_xdat_o ^ xdat_o ^ expected_xdat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h, xdat_o=%h",
                         dat_o, xdat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h, xdat_o=%h",
                         expected_dat_o, expected_xdat_o);
                $display("  Got:      dat_o=%h, xdat_o=%h",
                         dat_o, xdat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, ena_i, wre_i, xadr_i, xdat_i, xwre_i, dat_o, xdat_o);
    end

endmodule
