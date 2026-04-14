`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PRI;
    reg [1:0] SEL;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PRI(PRI),
        .SEL(SEL),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Standard MUX Mode (PRI=0, SEL=0)");
            PRI = 0;
            SEL = 2'b00;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Standard MUX Mode (PRI=0, SEL=1)");
            PRI = 0;
            SEL = 2'b01;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Standard MUX Mode (PRI=0, SEL=2)");
            PRI = 0;
            SEL = 2'b10;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Standard MUX Mode (PRI=0, SEL=3)");
            PRI = 0;
            SEL = 2'b11;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Priority Mode - in3 is highest non-zero");
            PRI = 1;
            in0 = 4'h1;
            in1 = 4'h2;
            in2 = 4'h3;
            in3 = 4'h4;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority Mode - in3 is zero, in2 is highest non-zero");
            PRI = 1;
            in0 = 4'h5;
            in1 = 4'h6;
            in2 = 4'h7;
            in3 = 4'h0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority Mode - in3, in2 are zero, in1 is highest non-zero");
            PRI = 1;
            in0 = 4'hE;
            in1 = 4'hF;
            in2 = 4'h0;
            in3 = 4'h0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Priority Mode - only in0 is non-zero");
            PRI = 1;
            in0 = 4'h9;
            in1 = 4'h0;
            in2 = 4'h0;
            in3 = 4'h0;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Priority Mode - All inputs are zero");
            PRI = 1;
            in0 = 4'h0;
            in1 = 4'h0;
            in2 = 4'h0;
            in3 = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Standard MUX Mode allows zero output (SEL=2, in2=0)");
            PRI = 0;
            SEL = 2'b10;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'h0;
            in3 = 4'hD;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Priority Mode - Complex conflict (in3=0, in2=C, in1=0, in0=A)");
            PRI = 1;
            in3 = 4'h0;
            in2 = 4'hC;
            in1 = 4'h0;
            in0 = 4'hA;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Transition from Priority Mode back to Standard MUX");

            PRI = 1;
            SEL = 2'b01;
            in0 = 4'h1;
            in1 = 4'h2;
            in2 = 4'h3;
            in3 = 4'h4;
            #1;
            PRI = 0;
            #1;

            check_outputs(4'h2);
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
