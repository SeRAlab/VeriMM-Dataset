`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x_in;
    wire [6:0] segs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x_in(x_in),
        .segs(segs)
    );
    task testcase000;

    begin
        test_num = 0;
        x_in = 4'h0;
        #10;
        $display("Test %0d: Input %h (Digit 0)", test_num, x_in);
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        x_in = 4'h1;
        #10;
        $display("Test %0d: Input %h (Digit 1)", test_num, x_in);
        #1;

        check_outputs(7'b0000110);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x_in = 4'h2;
        #10;
        $display("Test %0d: Input %h (Digit 2)", test_num, x_in);
        #1;

        check_outputs(7'b1011011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x_in = 4'h3;
        #10;
        $display("Test %0d: Input %h (Digit 3)", test_num, x_in);
        #1;

        check_outputs(7'b1001111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x_in = 4'h4;
        #10;
        $display("Test %0d: Input %h (Digit 4)", test_num, x_in);
        #1;

        check_outputs(7'b1100110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x_in = 4'h5;
        #10;
        $display("Test %0d: Input %h (Digit 5)", test_num, x_in);
        #1;

        check_outputs(7'b1101101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x_in = 4'h6;
        #10;
        $display("Test %0d: Input %h (Digit 6)", test_num, x_in);
        #1;

        check_outputs(7'b1111101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x_in = 4'h7;
        #10;
        $display("Test %0d: Input %h (Digit 7)", test_num, x_in);
        #1;

        check_outputs(7'b0000111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x_in = 4'h8;
        #10;
        $display("Test %0d: Input %h (Digit 8)", test_num, x_in);
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x_in = 4'h9;
        #10;
        $display("Test %0d: Input %h (Digit 9)", test_num, x_in);
        #1;

        check_outputs(7'b1101111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x_in = 4'hA;
        #10;
        $display("Test %0d: Input %h (Digit A)", test_num, x_in);
        #1;

        check_outputs(7'b1110111);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        x_in = 4'hB;
        #10;
        $display("Test %0d: Input %h (Digit B)", test_num, x_in);
        #1;

        check_outputs(7'b1111100);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        x_in = 4'hC;
        #10;
        $display("Test %0d: Input %h (Digit C)", test_num, x_in);
        #1;

        check_outputs(7'b0111001);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        x_in = 4'hD;
        #10;
        $display("Test %0d: Input %h (Digit D)", test_num, x_in);
        #1;

        check_outputs(7'b1011110);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        x_in = 4'hE;
        #10;
        $display("Test %0d: Input %h (Digit E)", test_num, x_in);
        #1;

        check_outputs(7'b1111001);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        x_in = 4'hF;
        #10;
        $display("Test %0d: Input %h (Digit F)", test_num, x_in);
        #1;

        check_outputs(7'b1110001);
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


        testcase000();
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [6:0] expected_segs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segs === (expected_segs ^ segs ^ expected_segs)) begin
                $display("PASS");
                $display("  Outputs: segs=%h",
                         segs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segs=%h",
                         expected_segs);
                $display("  Got:      segs=%h",
                         segs);
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
