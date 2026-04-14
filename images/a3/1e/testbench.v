`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in1;
    reg [2:0] in2;
    reg [2:0] in3;
    reg [2:0] in4;
    reg [1:0] s1;
    wire [2:0] m1out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .s1(s1),
        .m1out(m1out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting in1 (s1=11)", test_num);
            in1 = 3'b101; in2 = 3'b000; in3 = 3'b000; in4 = 3'b000;
            s1 = 2'b11;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting in2 (s1=10)", test_num);
            in1 = 3'b000; in2 = 3'b110; in3 = 3'b000; in4 = 3'b000;
            s1 = 2'b10;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting in3 (s1=01)", test_num);
            in1 = 3'b000; in2 = 3'b000; in3 = 3'b011; in4 = 3'b000;
            s1 = 2'b01;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Selecting in4 (s1=00)", test_num);
            in1 = 3'b111; in2 = 3'b111; in3 = 3'b111; in4 = 3'b100;
            s1 = 2'b00;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unique values test (s1=11)", test_num);
            in1 = 3'h1; in2 = 3'h2; in3 = 3'h3; in4 = 3'h4;
            s1 = 2'b11;
            #1;

            check_outputs(3'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unique values test (s1=10)", test_num);
            in1 = 3'h1; in2 = 3'h2; in3 = 3'h3; in4 = 3'h4;
            s1 = 2'b10;
            #1;

            check_outputs(3'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unique values test (s1=01)", test_num);
            in1 = 3'h1; in2 = 3'h2; in3 = 3'h3; in4 = 3'h4;
            s1 = 2'b01;
            #1;

            check_outputs(3'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unique values test (s1=00)", test_num);
            in1 = 3'h1; in2 = 3'h2; in3 = 3'h3; in4 = 3'h4;
            s1 = 2'b00;
            #1;

            check_outputs(3'h4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All bits high (s1=11)", test_num);
            in1 = 3'b111; in2 = 3'b000; in3 = 3'b000; in4 = 3'b000;
            s1 = 2'b11;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All bits low (s1=00)", test_num);
            in1 = 3'b111; in2 = 3'b111; in3 = 3'b111; in4 = 3'b000;
            s1 = 2'b00;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_m1out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m1out === (expected_m1out ^ m1out ^ expected_m1out)) begin
                $display("PASS");
                $display("  Outputs: m1out=%h",
                         m1out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m1out=%h",
                         expected_m1out);
                $display("  Got:      m1out=%h",
                         m1out);
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
