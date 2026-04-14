`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] S0;
    reg [3:0] S1;
    reg [3:0] S2;
    reg [3:0] S3;
    reg [3:0] S4;
    reg [3:0] S5;
    reg [3:0] S6;
    reg [3:0] S7;
    reg [3:0] Sel;
    reg [3:0] Write_Byte_En;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .S4(S4),
        .S5(S5),
        .S6(S6),
        .S7(S7),
        .Sel(Sel),
        .Write_Byte_En(Write_Byte_En),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            S0 = 4'h0; S1 = 4'h1; S2 = 4'h2; S3 = 4'h3;
            S4 = 4'h4; S5 = 4'h5; S6 = 4'h6; S7 = 4'h7;
            Write_Byte_En = 4'hE;
            Sel = 4'b0000;
            $display("Testcase %0d: Testing S0 (Sel=0000)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Sel = 4'b0001;
            $display("Testcase %0d: Testing S1 (Sel=0001)", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Sel = 4'b0010;
            $display("Testcase %0d: Testing S2 (Sel=0010)", test_num);
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Sel = 4'b0011;
            $display("Testcase %0d: Testing S3 (Sel=0011)", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Sel = 4'b0100;
            $display("Testcase %0d: Testing S4 (Sel=0100)", test_num);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Sel = 4'b0101;
            $display("Testcase %0d: Testing S5 (Sel=0101)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Sel = 4'b0110;
            $display("Testcase %0d: Testing S6 (Sel=0110)", test_num);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Sel = 4'b0111;
            $display("Testcase %0d: Testing S7 (Sel=0111)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            Sel = 4'b1000;
            $display("Testcase %0d: Testing Write_Byte_En (Sel=1000)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            Sel = 4'b1011;
            $display("Testcase %0d: Testing Write_Byte_En (Sel=1011)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            Sel = 4'b1111;
            $display("Testcase %0d: Testing Write_Byte_En (Sel=1111)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            Write_Byte_En = 4'hA;
            Sel = 4'b1000;
            $display("Testcase %0d: Testing Write_Byte_En Update (New Value 0xA)", test_num);
            #1;

            check_outputs(4'hA);
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
