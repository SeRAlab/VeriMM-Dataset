`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Bw;
    reg [4:0] Ra;
    reg [4:0] Rb;
    reg Regwr;
    reg [4:0] Rw;
    reg clk;
    reg reset;
    wire [31:0] Ba;
    wire [31:0] Bb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bw(Bw),
        .Ra(Ra),
        .Rb(Rb),
        .Regwr(Regwr),
        .Rw(Rw),
        .clk(clk),
        .reset(reset),
        .Ba(Ba),
        .Bb(Bb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            Regwr = 0;
            Ra = 0;
            Rb = 0;
            Rw = 0;
            Bw = 0;
            @(posedge clk);
            #2 reset = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Verify reset state", test_num);
            Ra = 5'd10;
            Rb = 5'd31;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Basic write and read", test_num);
            @(negedge clk);
            Regwr = 1; Rw = 5'd5; Bw = 32'hDEADBEEF;
            @(posedge clk);
            #2 Regwr = 0; Ra = 5'd5; Rb = 5'd0;
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verify Register 0 cannot be written", test_num);
            @(negedge clk);
            Regwr = 1; Rw = 5'd0; Bw = 32'hFFFFFFFF;
            @(posedge clk);
            #2 Regwr = 0; Ra = 5'd0; Rb = 5'd0;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Verify Regwr=0 prevents writing", test_num);
            @(negedge clk);
            Regwr = 0; Rw = 5'd12; Bw = 32'h5555AAAA;
            @(posedge clk);
            #2 Ra = 5'd12;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Max register index and simultaneous read", test_num);
            @(negedge clk);
            Regwr = 1; Rw = 5'd31; Bw = 32'h12345678;
            @(posedge clk);
            #2 Regwr = 0; Ra = 5'd31; Rb = 5'd31;
            #2;
            #1;

            check_outputs(32'h12345678, 32'h12345678);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Verify register value overwrite", test_num);
            @(negedge clk);
            Regwr = 1; Rw = 5'd2; Bw = 32'hAAAA_BBBB;
            @(posedge clk);
            @(negedge clk);
            Bw = 32'hCCCC_DDDD;
            @(posedge clk);
            #2 Regwr = 0; Ra = 5'd2; Rb = 5'd0;
            #2;
            #1;

            check_outputs(32'hCCCC_DDDD, 32'h0);
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
        input [31:0] expected_Ba;
        input [31:0] expected_Bb;
        begin
            if (expected_Ba === (expected_Ba ^ Ba ^ expected_Ba) &&
                expected_Bb === (expected_Bb ^ Bb ^ expected_Bb)) begin
                $display("PASS");
                $display("  Outputs: Ba=%h, Bb=%h",
                         Ba, Bb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ba=%h, Bb=%h",
                         expected_Ba, expected_Bb);
                $display("  Got:      Ba=%h, Bb=%h",
                         Ba, Bb);
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
        $dumpvars(0,Bw, Ra, Rb, Regwr, Rw, clk, reset, Ba, Bb);
    end

endmodule
