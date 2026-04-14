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
        test_num = test_num + 1;
        $display("\nTest %0d: All values comfortably within range", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd100; Cb = 8'd150; Cr = 8'd150;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Y below threshold Ta", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd40; Cb = 8'd150; Cr = 8'd150;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Y above threshold Tb", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd160; Cb = 8'd150; Cr = 8'd150;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Cb below threshold Tc", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd100; Cb = 8'd90; Cr = 8'd150;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Cr above threshold Td", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd100; Cb = 8'd150; Cr = 8'd210;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Exact lower boundary match", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd50; Cb = 8'd100; Cr = 8'd100;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Exact upper boundary match", test_num);
        Ta = 8'd50;  Tb = 8'd150;
        Tc = 8'd100; Td = 8'd200;
        Y = 8'd150; Cb = 8'd200; Cr = 8'd200;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: All values outside thresholds", test_num);
        Ta = 8'd100; Tb = 8'd110;
        Tc = 8'd100; Td = 8'd110;
        Y = 8'd0; Cb = 8'd255; Cr = 8'd255;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest %0d: Threshold range is a single point", test_num);
        Ta = 8'd128; Tb = 8'd128;
        Tc = 8'd128; Td = 8'd128;
        Y = 8'd128; Cb = 8'd128; Cr = 8'd128;
        #1;

        check_outputs(8'd1);
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
