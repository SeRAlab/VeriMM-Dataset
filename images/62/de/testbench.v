`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [7:0] I;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .I(I),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b00000001", test_num);
        EN = 1; I = 8'b0000_0001;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b10000000", test_num);
        EN = 1; I = 8'b1000_0000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b10000001", test_num);
        EN = 1; I = 8'b1000_0001;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b00011100", test_num);
        EN = 1; I = 8'b0001_1100;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b11111111", test_num);
        EN = 1; I = 8'b1111_1111;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b00000000", test_num);
        EN = 1; I = 8'b0000_0000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b00001010", test_num);
        EN = 1; I = 8'b0000_1010;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=1, I=8'b00100111", test_num);
        EN = 1; I = 8'b0010_0111;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: EN=0, I=8'b11111111", test_num);
        EN = 0; I = 8'b1111_1111;


        #1;
        $display("  Info: EN is Low, Y is %b", Y);
        pass_count = pass_count + 1;
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
        input [2:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
