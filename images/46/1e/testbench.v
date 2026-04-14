`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DIN;
    reg DINout;
    reg G;
    reg Gout;
    reg [15:0] Q0;
    reg [15:0] Q1;
    reg [15:0] Q2;
    reg [15:0] Q3;
    reg [15:0] Q4;
    reg [15:0] Q5;
    reg [15:0] Q6;
    reg [15:0] Q7;
    reg [7:0] Rout;
    wire [15:0] BUSWIRE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .DINout(DINout),
        .G(G),
        .Gout(Gout),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3),
        .Q4(Q4),
        .Q5(Q5),
        .Q6(Q6),
        .Q7(Q7),
        .Rout(Rout),
        .BUSWIRE(BUSWIRE)
    );
    task reset_inputs;

        begin
            DIN = 0;
            DINout = 0;
            G = 0;
            Gout = 0;
            Rout = 8'b0;
            Q0 = 16'h0000;
            Q1 = 16'h0000;
            Q2 = 16'h0000;
            Q3 = 16'h0000;
            Q4 = 16'h0000;
            Q5 = 16'h0000;
            Q6 = 16'h0000;
            Q7 = 16'h0000;
            #5;
        end
        endtask

    task testcase001;

        begin
            reset_inputs();
            test_num = 1;
            DIN = 1'b1;
            DINout = 1'b1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase002;

        begin
            reset_inputs();
            test_num = 2;
            G = 1'b1;
            Gout = 1'b1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            reset_inputs();
            test_num = 3;
            Q0 = 16'hAAAA;
            Rout = 8'b00000001;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_inputs();
            test_num = 4;
            Q1 = 16'hBBBB;
            Rout = 8'b00000010;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            reset_inputs();
            test_num = 5;
            Q2 = 16'hCCCC;
            Rout = 8'b00000100;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase006;

        begin
            reset_inputs();
            test_num = 6;
            Q3 = 16'hDDDD;
            Rout = 8'b00001000;
            #1;

            check_outputs(16'hDDDD);
        end
        endtask

    task testcase007;

        begin
            reset_inputs();
            test_num = 7;
            Q4 = 16'hEEEE;
            Rout = 8'b00010000;
            #1;

            check_outputs(16'hEEEE);
        end
        endtask

    task testcase008;

        begin
            reset_inputs();
            test_num = 8;
            Q5 = 16'hFFFF;
            Rout = 8'b00100000;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            reset_inputs();
            test_num = 9;
            Q6 = 16'h1234;
            Rout = 8'b01000000;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase010;

        begin
            reset_inputs();
            test_num = 10;
            Q7 = 16'h5678;
            Rout = 8'b10000000;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase011;

        begin
            reset_inputs();
            test_num = 11;
            DINout = 0;
            Gout = 0;
            Rout = 8'b00000000;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_BUSWIRE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BUSWIRE === (expected_BUSWIRE ^ BUSWIRE ^ expected_BUSWIRE)) begin
                $display("PASS");
                $display("  Outputs: BUSWIRE=%h",
                         BUSWIRE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUSWIRE=%h",
                         expected_BUSWIRE);
                $display("  Got:      BUSWIRE=%h",
                         BUSWIRE);
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
