`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLK;
    reg [2:0] OP;
    reg RST;
    wire [15:0] RES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .OP(OP),
        .RST(RST),
        .RES(RES)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 0;
            B = 0;
            OP = 0;
            @(posedge CLK);
            #1 RST = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'd25;
            B = 8'd15;
            OP = 3'b000;
            @(posedge CLK);
            #1 #1;
 check_outputs(16'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'd10;
            B = 8'd25;
            OP = 3'b001;
            @(posedge CLK);
            #1 #1;
 check_outputs(-16'd15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'd12;
            B = -8'd5;
            OP = 3'b010;
            @(posedge CLK);
            #1 #1;
 check_outputs(-16'd60);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'd100;
            B = 8'd4;
            OP = 3'b011;
            @(posedge CLK);
            #1 #1;
 check_outputs(16'd25);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = -8'd120;
            B = -8'd10;
            OP = 3'b000;
            @(posedge CLK);
            #1 #1;
 check_outputs(-16'd130);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = -8'd128;
            B = -8'd2;
            OP = 3'b010;
            @(posedge CLK);
            #1 #1;
 check_outputs(16'd256);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 8'd50;
            B = -8'd50;
            OP = 3'b001;
            @(posedge CLK);
            #1 #1;
 check_outputs(16'd100);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 8'd5;
            B = 8'd10;
            OP = 3'b011;
            @(posedge CLK);
            #1 #1;
 check_outputs(16'd0);
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
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_RES;
        begin
            if (expected_RES === (expected_RES ^ RES ^ expected_RES)) begin
                $display("PASS");
                $display("  Outputs: RES=%h",
                         RES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RES=%h",
                         expected_RES);
                $display("  Got:      RES=%h",
                         RES);
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
        $dumpvars(0,A, B, CLK, OP, RST, RES);
    end

endmodule
