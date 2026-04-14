`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D0;
    reg [7:0] D1;
    reg [7:0] D2;
    reg [7:0] D3;
    reg EN;
    reg [1:0] SEL;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .EN(EN),
        .SEL(SEL),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        EN = 0; SEL = 2'b00; D0 = 8'hAA; D1 = 8'hBB; D2 = 8'hCC; D3 = 8'hDD;
        $display("Test %0d: EN=0, SEL=00", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        EN = 0; SEL = 2'b11; D0 = 8'hAA; D1 = 8'hBB; D2 = 8'hCC; D3 = 8'hDD;
        $display("Test %0d: EN=0, SEL=11", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        EN = 1; SEL = 2'b00; D0 = 8'h11; D1 = 8'h22; D2 = 8'h33; D3 = 8'h44;
        $display("Test %0d: EN=1, SEL=00 (D0)", test_num);
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        EN = 1; SEL = 2'b01; D0 = 8'h11; D1 = 8'h22; D2 = 8'h33; D3 = 8'h44;
        $display("Test %0d: EN=1, SEL=01 (D1)", test_num);
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        EN = 1; SEL = 2'b10; D0 = 8'h11; D1 = 8'h22; D2 = 8'h33; D3 = 8'h44;
        $display("Test %0d: EN=1, SEL=10 (D2)", test_num);
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        EN = 1; SEL = 2'b11; D0 = 8'h11; D1 = 8'h22; D2 = 8'h33; D3 = 8'h44;
        $display("Test %0d: EN=1, SEL=11 (D3)", test_num);
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        EN = 1; SEL = 2'b00; D0 = 8'hFF; D1 = 8'h00; D2 = 8'h00; D3 = 8'h00;
        $display("Test %0d: EN=1, SEL=00, D0=FF", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        EN = 1; SEL = 2'b10; D0 = 8'h00; D1 = 8'h00; D2 = 8'hA5; D3 = 8'h00;
        $display("Test %0d: EN=1, SEL=10, D2=A5", test_num);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        EN = 1; SEL = 2'b01; D1 = 8'h55;
        #5;
        EN = 0;
        $display("Test %0d: EN 1->0 toggle, SEL=01", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        EN = 1; SEL = 2'b11; D0 = 8'h77; D1 = 8'h77; D2 = 8'h77; D3 = 8'h77;
        $display("Test %0d: All inputs identical", test_num);
        #1;

        check_outputs(8'h77);
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
        input [7:0] expected_Y;
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
