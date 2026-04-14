`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg mode;
    wire negative;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .mode(mode),
        .negative(negative)
    );

        task reset_dut;

        begin
            A = 16'd0;
            B = 16'd0;
            mode = 1'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'd100;
            B = 16'd50;
            mode = 1'b1;
            #100;
            $display("Testcase %0d: 100 - 50 (mode=1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'd50;
            B = 16'd100;
            mode = 1'b1;
            #100;
            $display("Testcase %0d: 50 - 100 (mode=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'hFFFF;
            B = 16'hFFFF;
            mode = 1'b1;
            #100;
            $display("Testcase %0d: 65535 - 65535 (mode=1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'd10;
            B = 16'd20;
            mode = 1'b0;
            #100;
            $display("Testcase %0d: 10 + 20 (mode=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'd0;
            B = 16'd1;
            mode = 1'b1;
            #100;
            $display("Testcase %0d: 0 - 1 (mode=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'hF000;
            B = 16'hEFFF;
            mode = 1'b1;
            #100;
            $display("Testcase %0d: 0xF000 - 0xEFFF (mode=1)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 16'h7FFF;
            B = 16'h8000;
            mode = 1'b1;
            #100;
            $display("Testcase %0d: 0x7FFF - 0x8000 (mode=1)", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_negative;
        begin
            if (expected_negative === (expected_negative ^ negative ^ expected_negative)) begin
                $display("PASS");
                $display("  Outputs: negative=%b",
                         negative);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: negative=%b",
                         expected_negative);
                $display("  Got:      negative=%b",
                         negative);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, mode, negative);
    end

endmodule
