`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Din0;
    reg [7:0] Din1;
    reg [7:0] Din10;
    reg [7:0] Din11;
    reg [7:0] Din12;
    reg [7:0] Din13;
    reg [7:0] Din14;
    reg [7:0] Din15;
    reg [7:0] Din2;
    reg [7:0] Din3;
    reg [7:0] Din4;
    reg [7:0] Din5;
    reg [7:0] Din6;
    reg [7:0] Din7;
    reg [7:0] Din8;
    reg [7:0] Din9;
    wire [127:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din0(Din0),
        .Din1(Din1),
        .Din10(Din10),
        .Din11(Din11),
        .Din12(Din12),
        .Din13(Din13),
        .Din14(Din14),
        .Din15(Din15),
        .Din2(Din2),
        .Din3(Din3),
        .Din4(Din4),
        .Din5(Din5),
        .Din6(Din6),
        .Din7(Din7),
        .Din8(Din8),
        .Din9(Din9),
        .Dout(Dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            Din0 = 8'h00; Din1 = 8'h00; Din2 = 8'h00; Din3 = 8'h00;
            Din4 = 8'h00; Din5 = 8'h00; Din6 = 8'h00; Din7 = 8'h00;
            Din8 = 8'h00; Din9 = 8'h00; Din10 = 8'h00; Din11 = 8'h00;
            Din12 = 8'h00; Din13 = 8'h00; Din14 = 8'h00; Din15 = 8'h00;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            Din0 = 8'hFF; Din1 = 8'hFF; Din2 = 8'hFF; Din3 = 8'hFF;
            Din4 = 8'hFF; Din5 = 8'hFF; Din6 = 8'hFF; Din7 = 8'hFF;
            Din8 = 8'hFF; Din9 = 8'hFF; Din10 = 8'hFF; Din11 = 8'hFF;
            Din12 = 8'hFF; Din13 = 8'hFF; Din14 = 8'hFF; Din15 = 8'hFF;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Sequential Bytes 00-0F", test_num);
            Din0 = 8'h00; Din1 = 8'h01; Din2 = 8'h02; Din3 = 8'h03;
            Din4 = 8'h04; Din5 = 8'h05; Din6 = 8'h06; Din7 = 8'h07;
            Din8 = 8'h08; Din9 = 8'h09; Din10 = 8'h0A; Din11 = 8'h0B;
            Din12 = 8'h0C; Din13 = 8'h0D; Din14 = 8'h0E; Din15 = 8'h0F;

            #1;


            check_outputs(128'h0F0E0D0C0B0A09080706050403020100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating AA and 55", test_num);
            Din0 = 8'hAA; Din1 = 8'h55; Din2 = 8'hAA; Din3 = 8'h55;
            Din4 = 8'hAA; Din5 = 8'h55; Din6 = 8'hAA; Din7 = 8'h55;
            Din8 = 8'hAA; Din9 = 8'h55; Din10 = 8'hAA; Din11 = 8'h55;
            Din12 = 8'hAA; Din13 = 8'h55; Din14 = 8'hAA; Din15 = 8'h55;
            #1;

            check_outputs(128'h55AA55AA55AA55AA55AA55AA55AA55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Prime-like/Unique values for mapping check", test_num);
            Din0 = 8'h11; Din1 = 8'h22; Din2 = 8'h33; Din3 = 8'h44;
            Din4 = 8'h55; Din5 = 8'h66; Din6 = 8'h77; Din7 = 8'h88;
            Din8 = 8'h99; Din9 = 8'hAA; Din10 = 8'hBB; Din11 = 8'hCC;
            Din12 = 8'hDD; Din13 = 8'hEE; Din14 = 8'hFF; Din15 = 8'h01;
            #1;

            check_outputs(128'h01FFEEDDCCBBAA998877665544332211);
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
        input [127:0] expected_Dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
