`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg FUNC_DONE;
    reg FUNC_READY;
    reg [31:0] LOCAL_ADDR;
    reg [3:0] LOCAL_BE;
    reg LOCAL_CS;
    reg LOCAL_RNW;
    reg [31:0] LOCAL_WDATA;
    reg RST_N;
    wire FUNC_START;
    wire LOCAL_ACK;
    wire [31:0] LOCAL_RDATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .FUNC_DONE(FUNC_DONE),
        .FUNC_READY(FUNC_READY),
        .LOCAL_ADDR(LOCAL_ADDR),
        .LOCAL_BE(LOCAL_BE),
        .LOCAL_CS(LOCAL_CS),
        .LOCAL_RNW(LOCAL_RNW),
        .LOCAL_WDATA(LOCAL_WDATA),
        .RST_N(RST_N),
        .FUNC_START(FUNC_START),
        .LOCAL_ACK(LOCAL_ACK),
        .LOCAL_RDATA(LOCAL_RDATA)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 0;
            LOCAL_CS = 0;
            LOCAL_RNW = 0;
            LOCAL_ADDR = 0;
            LOCAL_BE = 4'h0;
            LOCAL_WDATA = 0;
            FUNC_READY = 0;
            FUNC_DONE = 0;
            repeat(5) @(posedge CLK);
            RST_N = 1;
            repeat(2) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge CLK);
            LOCAL_ADDR = 32'h0000_0000;
            LOCAL_WDATA = 32'h0000_0001;
            LOCAL_BE = 4'hF;
            LOCAL_RNW = 1'b0;
            LOCAL_CS = 1'b1;


            wait(LOCAL_ACK == 1'b1);
            @(posedge CLK);



            #1;




            check_outputs(1'b1, 1'b1, 32'h0);

            LOCAL_CS = 1'b0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            FUNC_READY = 1'b1;
            FUNC_DONE = 1'b0;

            @(posedge CLK);
            LOCAL_ADDR = 32'h0000_0004;
            LOCAL_RNW = 1'b1;
            LOCAL_CS = 1'b1;
            LOCAL_BE = 4'hF;

            wait(LOCAL_ACK == 1'b1);
            @(posedge CLK);


            #1;



            check_outputs(1'b0, 1'b1, 32'h0000_0001);

            LOCAL_CS = 1'b0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            FUNC_READY = 1'b0;
            FUNC_DONE = 1'b1;

            @(posedge CLK);
            LOCAL_ADDR = 32'h0000_0004;
            LOCAL_RNW = 1'b1;
            LOCAL_CS = 1'b1;
            LOCAL_BE = 4'hF;

            wait(LOCAL_ACK == 1'b1);
            @(posedge CLK);


            #1;



            check_outputs(1'b0, 1'b1, 32'h0000_0002);

            LOCAL_CS = 1'b0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            LOCAL_CS = 1'b0;
            LOCAL_ADDR = 32'h0000_0008;
            LOCAL_WDATA = 32'hAAAA_BBBB;

            repeat(5) @(posedge CLK);


            #1;



            check_outputs(1'b0, 1'b0, 32'h0);
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
        input expected_FUNC_START;
        input expected_LOCAL_ACK;
        input [31:0] expected_LOCAL_RDATA;
        begin
            if (expected_FUNC_START === (expected_FUNC_START ^ FUNC_START ^ expected_FUNC_START) &&
                expected_LOCAL_ACK === (expected_LOCAL_ACK ^ LOCAL_ACK ^ expected_LOCAL_ACK) &&
                expected_LOCAL_RDATA === (expected_LOCAL_RDATA ^ LOCAL_RDATA ^ expected_LOCAL_RDATA)) begin
                $display("PASS");
                $display("  Outputs: FUNC_START=%b, LOCAL_ACK=%b, LOCAL_RDATA=%h",
                         FUNC_START, LOCAL_ACK, LOCAL_RDATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FUNC_START=%b, LOCAL_ACK=%b, LOCAL_RDATA=%h",
                         expected_FUNC_START, expected_LOCAL_ACK, expected_LOCAL_RDATA);
                $display("  Got:      FUNC_START=%b, LOCAL_ACK=%b, LOCAL_RDATA=%h",
                         FUNC_START, LOCAL_ACK, LOCAL_RDATA);
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
        $dumpvars(0,CLK, FUNC_DONE, FUNC_READY, LOCAL_ADDR, LOCAL_BE, LOCAL_CS, LOCAL_RNW, LOCAL_WDATA, RST_N, FUNC_START, LOCAL_ACK, LOCAL_RDATA);
    end

endmodule
