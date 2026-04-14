`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ByteIn;
    reg Enable;
    reg Polarity;
    wire [6:0] SegOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ByteIn(ByteIn),
        .Enable(Enable),
        .Polarity(Polarity),
        .SegOut(SegOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled State (Enable=0, Polarity=1, ByteIn=5)", test_num);
            ByteIn = 4'h5;
            Enable = 1'b0;
            Polarity = 1'b1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Polarity - Digit 0 (Enable=1, Polarity=1, ByteIn=0)", test_num);
            ByteIn = 4'h0;
            Enable = 1'b1;
            Polarity = 1'b1;

            #1;


            check_outputs(7'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Polarity - Digit 1 (Enable=1, Polarity=1, ByteIn=1)", test_num);
            ByteIn = 4'h1;
            Enable = 1'b1;
            Polarity = 1'b1;

            #1;


            check_outputs(7'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Polarity - Digit 8 (Enable=1, Polarity=1, ByteIn=8)", test_num);
            ByteIn = 4'h8;
            Enable = 1'b1;
            Polarity = 1'b1;

            #1;


            check_outputs(7'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Polarity - Digit F (Enable=1, Polarity=1, ByteIn=F)", test_num);
            ByteIn = 4'hF;
            Enable = 1'b1;
            Polarity = 1'b1;

            #1;


            check_outputs(7'h71);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverted Polarity - Digit 0 (Enable=1, Polarity=0, ByteIn=0)", test_num);
            ByteIn = 4'h0;
            Enable = 1'b1;
            Polarity = 1'b0;

            #1;


            check_outputs(7'h40);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Inverted Polarity - Digit 8 (Enable=1, Polarity=0, ByteIn=8)", test_num);
            ByteIn = 4'h8;
            Enable = 1'b1;
            Polarity = 1'b0;

            #1;


            check_outputs(7'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled state with Low Polarity (Enable=0, Polarity=0, ByteIn=A)", test_num);
            ByteIn = 4'hA;
            Enable = 1'b0;
            Polarity = 1'b0;

            #1;


            check_outputs(7'h00);
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
        input [6:0] expected_SegOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SegOut === (expected_SegOut ^ SegOut ^ expected_SegOut)) begin
                $display("PASS");
                $display("  Outputs: SegOut=%h",
                         SegOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SegOut=%h",
                         expected_SegOut);
                $display("  Got:      SegOut=%h",
                         SegOut);
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
