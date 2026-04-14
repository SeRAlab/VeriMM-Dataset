`timescale 1ns/1ps

module mux4_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg sel0;
    reg sel1;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel0(sel0),
        .sel1(sel1),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: sel1=0, sel0=0 (Both low) - Expected output: 0");
        in0 = 4'hA;
        in1 = 4'hB;
        in2 = 4'hC;
        in3 = 4'hD;
        sel1 = 0;
        sel0 = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: sel1=0, sel0=1 - Expected output: in1 (4'hB)");
        in0 = 4'hA;
        in1 = 4'hB;
        in2 = 4'hC;
        in3 = 4'hD;
        sel1 = 0;
        sel0 = 1;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: sel1=1, sel0=0 - Expected output: in2 (4'hC)");
        in0 = 4'hA;
        in1 = 4'hB;
        in2 = 4'hC;
        in3 = 4'hD;
        sel1 = 1;
        sel0 = 0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: sel1=1, sel0=1 (Both high) - Expected output: 0");
        in0 = 4'hA;
        in1 = 4'hB;
        in2 = 4'hC;
        in3 = 4'hD;
        sel1 = 1;
        sel0 = 1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: sel1=0, sel0=1 with different data - Expected output: in1 (4'hF)");
        in0 = 4'h0;
        in1 = 4'hF;
        in2 = 4'h5;
        in3 = 4'hE;
        sel1 = 0;
        sel0 = 1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: sel1=1, sel0=0 with different data - Expected output: in2 (4'h5)");
        in0 = 4'h0;
        in1 = 4'hF;
        in2 = 4'h5;
        in3 = 4'hE;
        sel1 = 1;
        sel0 = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4 Testbench");
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

endmodule
