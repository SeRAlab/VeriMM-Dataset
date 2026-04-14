`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] GPIO_I;
    reg [31:0] LOCAL_ADDR;
    reg [3:0] LOCAL_BE;
    reg LOCAL_CS;
    reg LOCAL_RNW;
    reg [31:0] LOCAL_WDATA;
    reg RST_N;
    wire [31:0] GPIO_OT;
    wire LOCAL_ACK;
    wire [31:0] LOCAL_RDATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .GPIO_I(GPIO_I),
        .LOCAL_ADDR(LOCAL_ADDR),
        .LOCAL_BE(LOCAL_BE),
        .LOCAL_CS(LOCAL_CS),
        .LOCAL_RNW(LOCAL_RNW),
        .LOCAL_WDATA(LOCAL_WDATA),
        .RST_N(RST_N),
        .GPIO_OT(GPIO_OT),
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
            LOCAL_ADDR = 32'h0;
            LOCAL_BE = 4'h0;
            LOCAL_WDATA = 32'h0;
            GPIO_I = 32'h0;
            repeat(5) @(posedge CLK);
            RST_N = 1;
            repeat(2) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;
            #1;

            check_outputs(32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge CLK);
            LOCAL_CS = 1;
            LOCAL_RNW = 0;
            LOCAL_ADDR = 32'h0;
            LOCAL_BE = 4'hF;
            LOCAL_WDATA = 32'hA5A5A5A5;


            while(LOCAL_ACK !== 1'b1) @(posedge CLK);


            #1;
            #1;

            check_outputs(32'hA5A5A5A5, 1'b1, 32'h0);

            @(posedge CLK);
            LOCAL_CS = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            GPIO_I = 32'h12345678;
            @(posedge CLK);
            LOCAL_CS = 1;
            LOCAL_RNW = 1;
            LOCAL_ADDR = 32'h0;
            LOCAL_BE = 4'hF;


            while(LOCAL_ACK !== 1'b1) @(posedge CLK);


            #1;
            #1;

            check_outputs(32'h0, 1'b1, 32'h12345678);

            @(posedge CLK);
            LOCAL_CS = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge CLK);
            LOCAL_CS = 1;
            LOCAL_RNW = 0;
            LOCAL_ADDR = 32'h0;
            LOCAL_BE = 4'hF;
            LOCAL_WDATA = 32'hFFFFFFFF;
            while(LOCAL_ACK !== 1'b1) @(posedge CLK);
            @(posedge CLK);
            LOCAL_CS = 0;


            repeat(2) @(posedge CLK);
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            @(posedge CLK);
            LOCAL_CS = 1;
            LOCAL_RNW = 0;
            LOCAL_ADDR = 32'h0;
            LOCAL_WDATA = 32'hCAFEBABE;
            LOCAL_BE = 4'hF;
            while(LOCAL_ACK !== 1'b1) @(posedge CLK);
            @(posedge CLK);
            LOCAL_CS = 0;


            @(posedge CLK);
            GPIO_I = 32'hDEADBEEF;
            LOCAL_CS = 1;
            LOCAL_RNW = 1;
            LOCAL_ADDR = 32'h0;
            while(LOCAL_ACK !== 1'b1) @(posedge CLK);


            #1;
            #1;

            check_outputs(32'hCAFEBABE, 1'b1, 32'hDEADBEEF);

            @(posedge CLK);
            LOCAL_CS = 0;
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
        input [31:0] expected_GPIO_OT;
        input expected_LOCAL_ACK;
        input [31:0] expected_LOCAL_RDATA;
        begin
            if (expected_GPIO_OT === (expected_GPIO_OT ^ GPIO_OT ^ expected_GPIO_OT) &&
                expected_LOCAL_ACK === (expected_LOCAL_ACK ^ LOCAL_ACK ^ expected_LOCAL_ACK) &&
                expected_LOCAL_RDATA === (expected_LOCAL_RDATA ^ LOCAL_RDATA ^ expected_LOCAL_RDATA)) begin
                $display("PASS");
                $display("  Outputs: GPIO_OT=%h, LOCAL_ACK=%b, LOCAL_RDATA=%h",
                         GPIO_OT, LOCAL_ACK, LOCAL_RDATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIO_OT=%h, LOCAL_ACK=%b, LOCAL_RDATA=%h",
                         expected_GPIO_OT, expected_LOCAL_ACK, expected_LOCAL_RDATA);
                $display("  Got:      GPIO_OT=%h, LOCAL_ACK=%b, LOCAL_RDATA=%h",
                         GPIO_OT, LOCAL_ACK, LOCAL_RDATA);
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
        $dumpvars(0,CLK, GPIO_I, LOCAL_ADDR, LOCAL_BE, LOCAL_CS, LOCAL_RNW, LOCAL_WDATA, RST_N, GPIO_OT, LOCAL_ACK, LOCAL_RDATA);
    end

endmodule
