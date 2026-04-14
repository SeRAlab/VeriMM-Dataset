`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CK;
    reg sub;
    wire Cout;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CK(CK),
        .sub(sub),
        .Cout(Cout),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            sub = 0;
            @(posedge CK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            sub = 1'b0;
            @(posedge CK); #1;
            $display("Testcase %03d: 5 + 3", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'd12;
            B = 4'd7;
            sub = 1'b0;
            @(posedge CK); #1;
            $display("Testcase %03d: 12 + 7 (Overflow)", test_num);
            #1;

            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            sub = 1'b0;
            @(posedge CK); #1;
            $display("Testcase %03d: 15 + 15", test_num);
            #1;

            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            sub = 1'b1;
            @(posedge CK); #1;
            $display("Testcase %03d: 10 - 4", test_num);

            #1;


            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 4'd4;
            B = 4'd10;
            sub = 1'b1;
            @(posedge CK); #1;
            $display("Testcase %03d: 4 - 10 (Negative)", test_num);


            #1;



            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'h7;
            B = 4'h7;
            sub = 1'b1;
            @(posedge CK); #1;
            $display("Testcase %03d: 7 - 7", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 4'd0;
            B = 4'd1;
            sub = 1'b1;
            @(posedge CK); #1;
            $display("Testcase %03d: 0 - 1", test_num);

            #1;


            check_outputs(1'b0, 4'hF);
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
        input expected_Cout;
        input [3:0] expected_Y;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Y=%h",
                         Cout, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Y=%h",
                         expected_Cout, expected_Y);
                $display("  Got:      Cout=%b, Y=%h",
                         Cout, Y);
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
        $dumpvars(0,A, B, CK, sub, Cout, Y);
    end

endmodule
