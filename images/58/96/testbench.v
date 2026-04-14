`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg [2:0] C;
    reg EN;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .EN(EN),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decoder Disabled (EN=0)", test_num);
            EN = 0;
            A = 3'b111; B = 3'b111; C = 3'b111;
            #1;

            check_outputs(8'b0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=000", test_num);
            EN = 1;
            A = 3'b000; B = 3'b000; C = 3'b000;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=001", test_num);
            EN = 1;
            A = 3'b000; B = 3'b000; C = 3'b001;
            #1;

            check_outputs(8'b0000_0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=010", test_num);
            EN = 1;
            A = 3'b000; B = 3'b001; C = 3'b000;
            #1;

            check_outputs(8'b0000_0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=011", test_num);
            EN = 1;
            A = 3'b000; B = 3'b001; C = 3'b001;
            #1;

            check_outputs(8'b0000_1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=100", test_num);
            EN = 1;
            A = 3'b001; B = 3'b000; C = 3'b000;
            #1;

            check_outputs(8'b0001_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=101", test_num);
            EN = 1;
            A = 3'b001; B = 3'b000; C = 3'b001;
            #1;

            check_outputs(8'b0010_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=110", test_num);
            EN = 1;
            A = 3'b001; B = 3'b001; C = 3'b000;
            #1;

            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, Input {A,B,C}=111", test_num);
            EN = 1;
            A = 3'b001; B = 3'b001; C = 3'b001;
            #1;

            check_outputs(8'b1000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0 (Disabled again with different input)", test_num);
            EN = 0;
            A = 3'b000; B = 3'b000; C = 3'b000;
            #1;

            check_outputs(8'b0000_0000);
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
