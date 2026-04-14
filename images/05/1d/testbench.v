`timescale 1ns/1ps

module GrayscaleConverter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] color_in;
    wire [4:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GrayscaleConverter dut (
        .color_in(color_in),
        .gray_out(gray_out)
    );
    task testcase001;

    begin
        test_num = 1;
        color_in = 5'b00000;
        $display("Testcase %0d: Input %b (R=0, G=0, B=0, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        color_in = 5'b11100;
        $display("Testcase %0d: Input %b (R=1, G=1, B=1, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        color_in = 5'b10000;
        $display("Testcase %0d: Input %b (R=1, G=0, B=0, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        color_in = 5'b01000;
        $display("Testcase %0d: Input %b (R=0, G=1, B=0, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        color_in = 5'b00100;
        $display("Testcase %0d: Input %b (R=0, G=0, B=1, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        color_in = 5'b11000;
        $display("Testcase %0d: Input %b (R=1, G=1, B=0, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        color_in = 5'b10100;
        $display("Testcase %0d: Input %b (R=1, G=0, B=1, Ignored=00)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        color_in = 5'b11111;
        $display("Testcase %0d: Input %b (R=1, G=1, B=1, Ignored=11)", test_num, color_in);
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        color_in = 5'b00011;
        $display("Testcase %0d: Input %b (R=0, G=0, B=0, Ignored=11)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        color_in = 5'b01101;
        $display("Testcase %0d: Input %b (R=0, G=1, B=1, Ignored=01)", test_num, color_in);
        #1;

        check_outputs(5'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GrayscaleConverter Testbench");
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
        input [4:0] expected_gray_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
