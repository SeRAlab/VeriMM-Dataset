`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Cin;
    wire [7:0] C;
    wire Cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .C(C),
        .Cout(Cout)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h00;
            B = 8'h00;
            Cin = 1'b0;
            $display("Test %0d: All zeros", test_num);
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'h12;
            B = 8'h34;
            Cin = 1'b0;
            $display("Test %0d: 0x12 + 0x34", test_num);
            #1;

            check_outputs(8'h46, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'h10;
            B = 8'h20;
            Cin = 1'b1;
            $display("Test %0d: 0x10 + 0x20 + Cin(1)", test_num);
            #1;

            check_outputs(8'h31, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'hAA;
            B = 8'h55;
            Cin = 1'b0;
            $display("Test %0d: 0xAA + 0x55 (result 0xFF)", test_num);
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hFF;
            B = 8'h01;
            Cin = 1'b0;
            $display("Test %0d: 0xFF + 0x01 (Overflow)", test_num);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hFF;
            B = 8'h00;
            Cin = 1'b1;
            $display("Test %0d: 0xFF + 0x00 + Cin(1)", test_num);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'hFF;
            B = 8'hFF;
            Cin = 1'b1;
            $display("Test %0d: 0xFF + 0xFF + Cin(1)", test_num);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'h0F;
            B = 8'h01;
            Cin = 1'b0;
            $display("Test %0d: Lower nibble carry", test_num);
            #1;

            check_outputs(8'h10, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'h55;
            B = 8'h55;
            Cin = 1'b0;
            $display("Test %0d: 0x55 + 0x55", test_num);
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'h80;
            B = 8'h80;
            Cin = 1'b0;
            $display("Test %0d: 0x80 + 0x80", test_num);
            #1;

            check_outputs(8'h00, 1'b1);
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
        input [7:0] expected_C;
        input expected_Cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Cout === (expected_Cout ^ Cout ^ expected_Cout)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Cout=%b",
                         C, Cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Cout=%b",
                         expected_C, expected_Cout);
                $display("  Got:      C=%h, Cout=%b",
                         C, Cout);
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
