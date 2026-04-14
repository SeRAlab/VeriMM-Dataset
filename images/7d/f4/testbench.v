`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg [3:0] B;
    reg [7:0] C;
    reg CLK;
    reg [31:0] D;
    wire E;
    wire [3:0] F;
    wire [7:0] G;
    wire [31:0] H;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .CLK(CLK),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .H(H)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        A = 0;
        B = 4'b0;
        C = 8'b0;
        D = 32'b0;
        @(posedge CLK);
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: All registers to high/max values", test_num);
        A = 1'b1;
        B = 4'hF;
        C = 8'hFF;
        D = 32'hFFFFFFFF;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1, 4'hF, 8'hFF, 32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 1010...", test_num);
        A = 1'b1;
        B = 4'hA;
        C = 8'hAA;
        D = 32'hAAAAAAAA;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1, 4'hA, 8'hAA, 32'hAAAAAAAA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 0101...", test_num);
        A = 1'b0;
        B = 4'h5;
        C = 8'h55;
        D = 32'h55555555;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 4'h5, 8'h55, 32'h55555555);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Walking bit or specific pattern", test_num);
        A = 1'b1;
        B = 4'h9;
        C = 8'hC3;
        D = 32'hDEADBEEF;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1, 4'h9, 8'hC3, 32'hDEADBEEF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Stability between clock cycles", test_num);


        A = 1'b1; B = 4'h3; C = 8'h12; D = 32'hCAFEBABE;
        @(posedge CLK);
        #2;


        A = 1'b0; B = 4'h0; C = 8'h00; D = 32'h0;




        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b0, 4'h0, 8'h00, 32'h0);
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
        input expected_E;
        input [3:0] expected_F;
        input [7:0] expected_G;
        input [31:0] expected_H;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_F === (expected_F ^ F ^ expected_F) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_H === (expected_H ^ H ^ expected_H)) begin
                $display("PASS");
                $display("  Outputs: E=%b, F=%h, G=%h, H=%h",
                         E, F, G, H);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, F=%h, G=%h, H=%h",
                         expected_E, expected_F, expected_G, expected_H);
                $display("  Got:      E=%b, F=%h, G=%h, H=%h",
                         E, F, G, H);
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
        $dumpvars(0,A, B, C, CLK, D, E, F, G, H);
    end

endmodule
