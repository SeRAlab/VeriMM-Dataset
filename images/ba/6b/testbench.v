`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg emit;
    reg [31:0] ia;
    reg [31:0] ib;
    reg [31:0] ic;
    reg [31:0] k0;
    reg [31:0] k1;
    reg [31:0] k2;
    reg onloop;
    reg [7:0] wcount;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .emit(emit),
        .ia(ia),
        .ib(ib),
        .ic(ic),
        .k0(k0),
        .k1(k1),
        .k2(k2),
        .onloop(onloop),
        .wcount(wcount),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            emit = 0;
            onloop = 0;
            wcount = 0;
            ia = 0; ib = 0; ic = 0;
            k0 = 0; k1 = 0; k2 = 0;
            repeat(2) @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Behavior");
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic Hash Cycle");
            reset_dut();
            ia = 32'hA5A5A5A5; ib = 32'h5A5A5A5A; ic = 32'h12345678;
            k0 = 32'h00000001; k1 = 32'h00000002; k2 = 32'h00000003;
            onloop = 1;
            wcount = 8'h01;
            @(posedge CLK);
            emit = 1;
            @(posedge CLK);
            emit = 0;
            onloop = 0;


            #1;



            check_outputs(o);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Multi-round Loop Processing");
            reset_dut();
            ia = 32'h1; ib = 32'h2; ic = 32'h3;
            k0 = 32'hF0F0F0F0; k1 = 32'h0F0F0F0F; k2 = 32'hABCDEF01;
            onloop = 1;
            for(i=0; i<16; i=i+1) begin
                wcount = i;
                @(posedge CLK);
            end
            onloop = 0;
            emit = 1;
            @(posedge CLK);
            emit = 0;
            #1;

            check_outputs(o);
        end
        endtask

    task testcase004;

        reg [31:0] initial_o;
        begin
            $display("\nRunning testcase004: Emit Signal Dependency");
            reset_dut();

            ia = 32'h11111111; emit = 1; @(posedge CLK);
            emit = 0; @(posedge CLK);
            initial_o = o;


            ia = 32'hEEEEEEEE;
            ib = 32'hFFFFFFFF;
            onloop = 1;
            repeat(5) @(posedge CLK);


            #1;



            check_outputs(initial_o);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Boundary Counters and Keys");
            reset_dut();
            ia = 32'hFFFFFFFF; ib = 32'hFFFFFFFF; ic = 32'hFFFFFFFF;
            k0 = 32'hAAAAAAAA; k1 = 32'h55555555; k2 = 32'h00000000;
            wcount = 8'hFF;
            onloop = 1;
            @(posedge CLK);
            emit = 1;
            @(posedge CLK);
            emit = 0;
            #1;

            check_outputs(o);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Continuous Emit Cycles");
            reset_dut();
            onloop = 1;
            ia = 32'hC0FFEE01; ib = 32'hC0FFEE02; ic = 32'hC0FFEE03;
            emit = 1;
            wcount = 8'd10;
            @(posedge CLK);
            ia = 32'hDEADBEEF;
            wcount = 8'd11;
            @(posedge CLK);
            ia = 32'hBADC0FFE;
            wcount = 8'd12;
            @(posedge CLK);
            emit = 0;
            #1;

            check_outputs(o);
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
        input [31:0] expected_o;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
        $dumpvars(0,CLK, RST, emit, ia, ib, ic, k0, k1, k2, onloop, wcount, o);
    end

endmodule
