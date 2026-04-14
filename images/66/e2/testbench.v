`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [7:0] D;
    reg [3:0] DPRA;
    reg WCLK;
    reg WE;
    wire [7:0] DPO;
    wire [7:0] SPO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .D(D),
        .DPRA(DPRA),
        .WCLK(WCLK),
        .WE(WE),
        .DPO(DPO),
        .SPO(SPO)
    );

    // Clock generation (10ns period)
    initial begin
        WCLK = 0;
        forever #5 WCLK = ~WCLK;
    end

        task reset_dut;

    begin
        A = 4'd0;
        D = 8'd0;
        DPRA = 4'd0;
        WE = 1'b0;
        @(negedge WCLK);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write and Dual Port Read Verification", test_num);

        @(negedge WCLK);
        A = 4'h5;
        D = 8'hA5;
        WE = 1'b1;
        @(posedge WCLK);
        #2;
        WE = 1'b0;


        DPRA = 4'h5;
        #2;
        #1;

        check_outputs(8'hA5, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Verifying Write Enable (WE=0 prevents writing)", test_num);


        @(negedge WCLK);
        A = 4'h2;
        D = 8'h11;
        WE = 1'b1;
        @(posedge WCLK);
        #2;


        WE = 1'b0;
        D = 8'hEE;
        @(posedge WCLK);
        #2;

        DPRA = 4'h2;
        #1;

        #1;


        check_outputs(8'h11, 8'h11);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Dual Port Simultaneous Read from different addresses", test_num);


        @(negedge WCLK);
        A = 4'h3; D = 8'h33; WE = 1'b1;
        @(posedge WCLK);
        #2;


        A = 4'h7; D = 8'h77; WE = 1'b1;
        @(posedge WCLK);
        #2;

        WE = 1'b0;
        A = 4'h3;
        DPRA = 4'h7;
        #5;
        #1;

        check_outputs(8'h77, 8'h33);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Overwriting an existing memory location", test_num);

        @(negedge WCLK);
        A = 4'hC; D = 8'h01; WE = 1'b1;
        @(posedge WCLK);
        #2;

        D = 8'hFF;
        @(posedge WCLK);
        #2;

        WE = 1'b0;
        DPRA = 4'hC;
        #2;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Boundary Address Check (0 and 15)", test_num);


        @(negedge WCLK);
        A = 4'h0; D = 8'h10; WE = 1'b1;
        @(posedge WCLK);
        #2;


        A = 4'hF; D = 8'hF0; WE = 1'b1;
        @(posedge WCLK);
        #2;

        WE = 1'b0;
        A = 4'hF;
        DPRA = 4'h0;
        #2;
        #1;

        check_outputs(8'h10, 8'hF0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Verifying reads are combinational (asynchronous)", test_num);


        @(negedge WCLK);
        A = 4'h8; D = 8'h88; WE = 1'b1;
        @(posedge WCLK);
        #2;


        A = 4'h9; D = 8'h99; WE = 1'b1;
        @(posedge WCLK);
        #2;

        WE = 1'b0;

        A = 4'h8; DPRA = 4'h9;
        #1;


        if (SPO == 8'h88 && DPO == 8'h99) begin
            A = 4'h9; DPRA = 4'h8;
            #1;
            #1;

            check_outputs(8'h88, 8'h99);
        end else begin
            $display("FAIL: Asynchronous read timing failed");
            fail_count = fail_count + 1;
        end
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
        input [7:0] expected_DPO;
        input [7:0] expected_SPO;
        begin
            if (expected_DPO === (expected_DPO ^ DPO ^ expected_DPO) &&
                expected_SPO === (expected_SPO ^ SPO ^ expected_SPO)) begin
                $display("PASS");
                $display("  Outputs: DPO=%h, SPO=%h",
                         DPO, SPO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DPO=%h, SPO=%h",
                         expected_DPO, expected_SPO);
                $display("  Got:      DPO=%h, SPO=%h",
                         DPO, SPO);
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
        $dumpvars(0,A, D, DPRA, WCLK, WE, DPO, SPO);
    end

endmodule
