`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [15:0] I;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .I(I),
        .O(O)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin
            I = 16'h0000;

            @(negedge EN);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h8000;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Input Bit 15 set", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h4000;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Input Bit 14 set", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h0800;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Input Bit 11 set (Group 2)", test_num);
            #1;

            check_outputs(4'd11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h0001;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Input Bit 0 set", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h8001;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Priority Check (Bits 15 and 0)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h00F0;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Multiple bits in Group 1", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h0010;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Boundary bit 4", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h0100;
            @(posedge EN);
            #2;
            $display("Testcase %0d: Boundary bit 8", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'h0000;
            @(posedge EN);
            #2;
            $display("Testcase %0d: All zeros input", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            I = 16'hFFFF;
            @(negedge EN);
            #2;
            $display("Testcase %0d: EN is Low check", test_num);

            #1;


            check_outputs(4'd0);
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
        input [3:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
        $dumpvars(0,EN, I, O);
    end

endmodule
