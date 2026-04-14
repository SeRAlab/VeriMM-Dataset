`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CONFIG_CPL_BOUNDARY_SEL;
    reg [11:0] CONFIG_MAX_CPL_DATA;
    reg [7:0] CONFIG_MAX_CPL_HDR;
    reg [2:0] CONFIG_MAX_READ_REQUEST_SIZE;
    reg RST;
    reg RX_ENG_RD_DONE;
    reg TX_ENG_RD_REQ_SENT;
    wire RXBUF_SPACE_AVAIL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CONFIG_CPL_BOUNDARY_SEL(CONFIG_CPL_BOUNDARY_SEL),
        .CONFIG_MAX_CPL_DATA(CONFIG_MAX_CPL_DATA),
        .CONFIG_MAX_CPL_HDR(CONFIG_MAX_CPL_HDR),
        .CONFIG_MAX_READ_REQUEST_SIZE(CONFIG_MAX_READ_REQUEST_SIZE),
        .RST(RST),
        .RX_ENG_RD_DONE(RX_ENG_RD_DONE),
        .TX_ENG_RD_REQ_SENT(TX_ENG_RD_REQ_SENT),
        .RXBUF_SPACE_AVAIL(RXBUF_SPACE_AVAIL)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            CONFIG_CPL_BOUNDARY_SEL = 0;
            CONFIG_MAX_CPL_DATA = 12'h200;
            CONFIG_MAX_CPL_HDR = 8'h40;
            CONFIG_MAX_READ_REQUEST_SIZE = 3'b000;
            RX_ENG_RD_DONE = 0;
            TX_ENG_RD_REQ_SENT = 0;
            repeat(5) @(posedge CLK);
            RST = 0;
            repeat(2) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Availability Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Deplete Data Credits");
            test_num = 2;
            reset_dut();


            CONFIG_MAX_CPL_DATA = 12'd32;
            CONFIG_MAX_READ_REQUEST_SIZE = 3'b001;
            repeat(2) @(posedge CLK);


            TX_ENG_RD_REQ_SENT = 1; @(posedge CLK);
            TX_ENG_RD_REQ_SENT = 0; repeat(2) @(posedge CLK);


            TX_ENG_RD_REQ_SENT = 1; @(posedge CLK);
            TX_ENG_RD_REQ_SENT = 0; repeat(2) @(posedge CLK);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Recovery after Completion");
            test_num = 3;
            reset_dut();

            CONFIG_MAX_CPL_DATA = 12'd16;
            CONFIG_MAX_READ_REQUEST_SIZE = 3'b000;
            repeat(2) @(posedge CLK);


            repeat(2) begin
                TX_ENG_RD_REQ_SENT = 1; @(posedge CLK);
                TX_ENG_RD_REQ_SENT = 0; repeat(1) @(posedge CLK);
            end


            RX_ENG_RD_DONE = 1; @(posedge CLK);
            RX_ENG_RD_DONE = 0; repeat(5) @(posedge CLK);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Deplete Header Credits");
            test_num = 4;
            reset_dut();

            CONFIG_MAX_CPL_DATA = 12'hFFF;
            CONFIG_MAX_CPL_HDR = 8'd2;
            CONFIG_CPL_BOUNDARY_SEL = 0;
            CONFIG_MAX_READ_REQUEST_SIZE = 3'b000;

            repeat(2) @(posedge CLK);


            TX_ENG_RD_REQ_SENT = 1; @(posedge CLK);
            TX_ENG_RD_REQ_SENT = 0; repeat(2) @(posedge CLK);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Large Request Size Check");
            test_num = 5;
            reset_dut();


            CONFIG_MAX_CPL_DATA = 12'd255;
            CONFIG_MAX_READ_REQUEST_SIZE = 3'b101;
            repeat(5) @(posedge CLK);



            #1;




            check_outputs(1'b0);
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
        input expected_RXBUF_SPACE_AVAIL;
        begin
            if (expected_RXBUF_SPACE_AVAIL === (expected_RXBUF_SPACE_AVAIL ^ RXBUF_SPACE_AVAIL ^ expected_RXBUF_SPACE_AVAIL)) begin
                $display("PASS");
                $display("  Outputs: RXBUF_SPACE_AVAIL=%b",
                         RXBUF_SPACE_AVAIL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RXBUF_SPACE_AVAIL=%b",
                         expected_RXBUF_SPACE_AVAIL);
                $display("  Got:      RXBUF_SPACE_AVAIL=%b",
                         RXBUF_SPACE_AVAIL);
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
        $dumpvars(0,CLK, CONFIG_CPL_BOUNDARY_SEL, CONFIG_MAX_CPL_DATA, CONFIG_MAX_CPL_HDR, CONFIG_MAX_READ_REQUEST_SIZE, RST, RX_ENG_RD_DONE, TX_ENG_RD_REQ_SENT, RXBUF_SPACE_AVAIL);
    end

endmodule
