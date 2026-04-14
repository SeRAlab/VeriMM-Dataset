`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] AI;
    reg BCD;
    reg [7:0] BI;
    reg CI;
    reg RDY;
    reg clk;
    reg [3:0] op;
    reg right;
    wire CO;
    wire HC;
    wire N;
    wire [7:0] OUT;
    wire V;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AI(AI),
        .BCD(BCD),
        .BI(BI),
        .CI(CI),
        .RDY(RDY),
        .clk(clk),
        .op(op),
        .right(right),
        .CO(CO),
        .HC(HC),
        .N(N),
        .OUT(OUT),
        .V(V),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        RDY <= 0;
        AI <= 0;
        BI <= 0;
        CI <= 0;
        op <= 0;
        BCD <= 0;
        right <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Binary Addition (10 + 20)", test_num);
        AI <= 8'h10;
        BI <= 8'h20;
        CI <= 0;
        op <= 4'h3;
        BCD <= 0;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 0, 8'h30, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Addition with Carry-Out and Zero Flag (FF + 01)", test_num);
        AI <= 8'hFF;
        BI <= 8'h01;
        CI <= 0;
        op <= 4'h3;
        BCD <= 0;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 1, 0, 8'h00, 0, 1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: BCD Addition (09 + 01 = 10)", test_num);
        AI <= 8'h09;
        BI <= 8'h01;
        CI <= 0;
        op <= 4'h3;
        BCD <= 1;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 0, 8'h10, 0, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Logical AND and Negative Flag", test_num);
        AI <= 8'hF0;
        BI <= 8'h80;
        CI <= 0;
        op <= 4'h1;
        BCD <= 0;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 1, 8'h80, 0, 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Logical XOR", test_num);
        AI <= 8'hAA;
        BI <= 8'h55;
        op <= 4'h2;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 1, 8'hFF, 0, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Signed Overflow Detection (7F + 01)", test_num);
        AI <= 8'h7F;
        BI <= 8'h01;
        CI <= 0;
        op <= 4'h3;
        BCD <= 0;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 1, 8'h80, 1, 0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: RDY Signal Check (Operation should not occur)", test_num);

        AI <= 8'h11; BI <= 8'h11; op <= 4'h3; RDY <= 1;
        @(posedge clk); #2;

        RDY <= 0;
        AI <= 8'hFF;
        BI <= 8'hFF;
        @(posedge clk);
        #2;

        if (OUT == 8'h22) begin
            $display("PASS: Output stayed constant while RDY=0");
            pass_count++;
        end else begin
            $display("FAIL: Output changed while RDY=0. Got %h", OUT);
            fail_count++;
        end
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Testcase %0d: Right Shift Check", test_num);
        AI <= 8'h02;
        right <= 1;
        op <= 4'h4;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 0, 8'h01, 0, 0);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Testcase %0d: Subtraction (Binary 20 - 05)", test_num);
        AI <= 8'h20;
        BI <= 8'h05;
        CI <= 1;
        op <= 4'h5;
        BCD <= 0;
        RDY <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0, 0, 8'h1B, 0, 0);
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
        testcase009();
        
        
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
        input expected_CO;
        input expected_HC;
        input expected_N;
        input [7:0] expected_OUT;
        input expected_V;
        input expected_Z;
        begin
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_HC === (expected_HC ^ HC ^ expected_HC) &&
                expected_N === (expected_N ^ N ^ expected_N) &&
                expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, HC=%b, N=%b, OUT=%h, V=%b, Z=%b",
                         CO, HC, N, OUT, V, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, HC=%b, N=%b, OUT=%h, V=%b, Z=%b",
                         expected_CO, expected_HC, expected_N, expected_OUT, expected_V, expected_Z);
                $display("  Got:      CO=%b, HC=%b, N=%b, OUT=%h, V=%b, Z=%b",
                         CO, HC, N, OUT, V, Z);
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
        $dumpvars(0,AI, BCD, BI, CI, RDY, clk, op, right, CO, HC, N, OUT, V, Z);
    end

endmodule
