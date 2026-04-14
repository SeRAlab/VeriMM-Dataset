`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ain;
    reg [4:0] bin;
    wire [15:0] yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .yout(yout)
    );
    task testcase001;

    begin
        test_num = 1;
        ain = 16'hABCD;
        bin = 5'b00000;
        $display("Test %0d: Left shift 0 bits", test_num);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ain = 16'h8001;
        bin = 5'b00001;
        $display("Test %0d: Left shift 1 bit", test_num);
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ain = 16'h00FF;
        bin = 5'b01000;
        $display("Test %0d: Left shift 8 bits", test_num);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ain = 16'h0001;
        bin = 5'b01111;
        $display("Test %0d: Left shift 15 bits", test_num);
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ain = 16'h1234;
        bin = 5'b10000;
        $display("Test %0d: Right shift 0 bits", test_num);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ain = 16'h8001;
        bin = 5'b10001;
        $display("Test %0d: Right shift 1 bit", test_num);
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ain = 16'hFF00;
        bin = 5'b11000;
        $display("Test %0d: Right shift 8 bits", test_num);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ain = 16'h8000;
        bin = 5'b11111;
        $display("Test %0d: Right shift 15 bits", test_num);
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ain = 16'hFFFF;
        bin = 5'b00100;
        $display("Test %0d: Left shift FFFF by 4 bits", test_num);
        #1;

        check_outputs(16'hFFF0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ain = 16'hAAAA;
        bin = 5'b10010;
        $display("Test %0d: Right shift AAAA by 2 bits", test_num);
        #1;

        check_outputs(16'h2AAA);
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
        input [15:0] expected_yout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: yout=%h",
                         yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yout=%h",
                         expected_yout);
                $display("  Got:      yout=%h",
                         yout);
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
