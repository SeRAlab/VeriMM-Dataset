`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hex;
    wire [7:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex(hex),
        .segments(segments)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input hex = 0", test_num);
        hex = 4'h0;
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input hex = 1", test_num);
        hex = 4'h1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input hex = 2", test_num);
        hex = 4'h2;
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input hex = 3", test_num);
        hex = 4'h3;
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input hex = 4", test_num);
        hex = 4'h4;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input hex = 5", test_num);
        hex = 4'h5;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input hex = 6", test_num);
        hex = 4'h6;
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Input hex = 7", test_num);
        hex = 4'h7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Input hex = 8", test_num);
        hex = 4'h8;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Input hex = 9", test_num);
        hex = 4'h9;
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Input hex = A (Invalid Digit)", test_num);
        hex = 4'hA;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Input hex = F (Invalid Digit)", test_num);
        hex = 4'hF;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: segments=%h",
                         segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h",
                         expected_segments);
                $display("  Got:      segments=%h",
                         segments);
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
