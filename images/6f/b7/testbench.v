`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EscrReg;
    reg [4:0] RegEscr;
    reg [4:0] RegLe1;
    reg [4:0] RegLe2;
    reg clk;
    reg [31:0] datain;
    reg reset;
    wire [31:0] data1;
    wire [31:0] data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EscrReg(EscrReg),
        .RegEscr(RegEscr),
        .RegLe1(RegLe1),
        .RegLe2(RegLe2),
        .clk(clk),
        .datain(datain),
        .reset(reset),
        .data1(data1),
        .data2(data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            EscrReg = 0;
            RegEscr = 0;
            datain = 0;
            RegLe1 = 0;
            RegLe2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Reset Values");
            reset_dut();

            RegLe1 = 5'd0;
            RegLe2 = 5'd31;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Register Write/Read");
            reset_dut();


            @(posedge clk);
            EscrReg = 1;
            RegEscr = 5'd5;
            datain = 32'hABCDE001;

            @(posedge clk);
            #1;
            EscrReg = 0;
            RegLe1 = 5'd5;
            RegLe2 = 5'd5;

            #5;
            #1;

            check_outputs(32'hABCDE001, 32'hABCDE001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Simultaneous Read of Two Registers");
            reset_dut();


            @(posedge clk);
            EscrReg = 1;
            RegEscr = 5'd10;
            datain = 32'h11112222;


            @(posedge clk);
            RegEscr = 5'd20;
            datain = 32'hAAAA5555;

            @(posedge clk);
            #1;
            EscrReg = 0;
            RegLe1 = 5'd10;
            RegLe2 = 5'd20;

            #5;
            #1;

            check_outputs(32'h11112222, 32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable Logic");
            reset_dut();


            @(posedge clk);
            EscrReg = 0;
            RegEscr = 5'd15;
            datain = 32'hFFFFFFFF;

            @(posedge clk);
            #1;
            RegLe1 = 5'd15;
            RegLe2 = 5'd0;

            #5;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Register 31");
            reset_dut();

            @(posedge clk);
            EscrReg = 1;
            RegEscr = 5'd31;
            datain = 32'h98765432;

            @(posedge clk);
            #1;
            EscrReg = 0;
            RegLe1 = 5'd31;
            RegLe2 = 5'd0;

            #5;
            #1;

            check_outputs(32'h98765432, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset Override");
            reset_dut();


            @(posedge clk);
            EscrReg = 1;
            RegEscr = 5'd7;
            datain = 32'h12341234;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            RegLe1 = 5'd7;

            #5;

            #1;


            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_data1;
        input [31:0] expected_data2;
        begin
            if (expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data2 === (expected_data2 ^ data2 ^ expected_data2)) begin
                $display("PASS");
                $display("  Outputs: data1=%h, data2=%h",
                         data1, data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data1=%h, data2=%h",
                         expected_data1, expected_data2);
                $display("  Got:      data1=%h, data2=%h",
                         data1, data2);
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
        $dumpvars(0,EscrReg, RegEscr, RegLe1, RegLe2, clk, datain, reset, data1, data2);
    end

endmodule
