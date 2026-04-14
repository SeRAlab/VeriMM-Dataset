`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Cb;
    reg [7:0] Cr;
    reg [7:0] Ta;
    reg [7:0] Tb;
    reg [7:0] Tc;
    reg [7:0] Td;
    reg [7:0] Y;
    wire [7:0] binary;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cb(Cb),
        .Cr(Cr),
        .Ta(Ta),
        .Tb(Tb),
        .Tc(Tc),
        .Td(Td),
        .Y(Y),
        .binary(binary)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Middle of Range (Success)", test_num);
        Y = 8'd128;
        Cb = 8'd100; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd100; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Cb < Ta (Failure)", test_num);
        Y = 8'd128;
        Cb = 8'd40;  Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd100; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Cb > Tb (Failure)", test_num);
        Y = 8'd128;
        Cb = 8'd160; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd100; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Cr < Tc (Failure)", test_num);
        Y = 8'd128;
        Cb = 8'd100; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd40;  Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Cr > Td (Failure)", test_num);
        Y = 8'd128;
        Cb = 8'd100; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd160; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Cb=Ta and Cr=Tc (Success)", test_num);
        Y = 8'd128;
        Cb = 8'd50; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd50; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Cb=Tb and Cr=Td (Success)", test_num);
        Y = 8'd128;
        Cb = 8'd150; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd150; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Cb=Ta-1 (Failure)", test_num);
        Y = 8'd128;
        Cb = 8'd49;  Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd100; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Different Y value (Success)", test_num);
        Y = 8'd0;
        Cb = 8'd100; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd100; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Y at max (Success)", test_num);
        Y = 8'd255;
        Cb = 8'd100; Ta = 8'd50; Tb = 8'd150;
        Cr = 8'd100; Tc = 8'd50; Td = 8'd150;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Full Range 0-255 (Success)", test_num);
        Y = 8'd128;
        Cb = 8'd0;   Ta = 8'd0; Tb = 8'd255;
        Cr = 8'd255; Tc = 8'd0; Td = 8'd255;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Single value window Ta=Tb=Cb (Success)", test_num);
        Y = 8'd128;
        Cb = 8'd128; Ta = 8'd128; Tb = 8'd128;
        Cr = 8'd128; Tc = 8'd128; Td = 8'd128;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_binary;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary === (expected_binary ^ binary ^ expected_binary)) begin
                $display("PASS");
                $display("  Outputs: binary=%h",
                         binary);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary=%h",
                         expected_binary);
                $display("  Got:      binary=%h",
                         binary);
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
