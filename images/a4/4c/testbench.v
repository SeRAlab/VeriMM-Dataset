`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg LEFT;
    reg LOG;
    reg [4:0] S;
    reg [31:0] X;
    wire [31:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LEFT(LEFT),
        .LOG(LOG),
        .S(S),
        .X(X),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            X = 32'hA0000000;
            S = 5'd4;
            LEFT = 1'b0;
            LOG = 1'b1;
            $display("Testcase %0d: Logical Right Shift, Positive X", test_num);
            #1;

            check_outputs(32'h0A000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            X = 32'h80000001;
            S = 5'd1;
            LEFT = 1'b0;
            LOG = 1'b1;
            $display("Testcase %0d: Logical Right Shift, Negative X", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            X = 32'h70000000;
            S = 5'd4;
            LEFT = 1'b0;
            LOG = 1'b0;
            $display("Testcase %0d: Arithmetic Right Shift, Positive X", test_num);
            #1;

            check_outputs(32'h07000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            X = 32'h80000000;
            S = 5'd4;
            LEFT = 1'b0;
            LOG = 1'b0;
            $display("Testcase %0d: Arithmetic Right Shift, Negative X", test_num);
            #1;

            check_outputs(32'hF8000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            X = 32'h000000FF;
            S = 5'd8;
            LEFT = 1'b1;
            LOG = 1'b1;
            $display("Testcase %0d: Logical Left Shift", test_num);
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            X = 32'hF0000001;
            S = 5'd4;
            LEFT = 1'b1;
            LOG = 1'b0;
            $display("Testcase %0d: Arithmetic Left Shift", test_num);
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            X = 32'h12345678;
            S = 5'd0;
            LEFT = 1'b0;
            LOG = 1'b0;
            $display("Testcase %0d: Shift by zero", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            X = 32'hFFFFFFFF;
            S = 5'd31;
            LEFT = 1'b0;
            LOG = 1'b1;
            $display("Testcase %0d: Logical Right Shift by 31", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            X = 32'h80000000;
            S = 5'd31;
            LEFT = 1'b0;
            LOG = 1'b0;
            $display("Testcase %0d: Arithmetic Right Shift by 31", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            X = 32'h00000001;
            S = 5'd31;
            LEFT = 1'b1;
            LOG = 1'b1;
            $display("Testcase %0d: Left Shift by 31", test_num);
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            X = 32'h00000000;
            S = 5'd16;
            LEFT = 1'b0;
            LOG = 1'b0;
            $display("Testcase %0d: Input Zero", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            X = 32'hFFFFFFFF;
            S = 5'd16;
            LEFT = 1'b0;
            LOG = 1'b0;
            $display("Testcase %0d: Input All Ones ASR", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
