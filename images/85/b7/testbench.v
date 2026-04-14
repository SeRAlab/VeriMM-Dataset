`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [7:0] I;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .I(I),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

    begin
        I = 8'b0;

        @(negedge EN);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input Bit 0 active (I=8'h01)", test_num);
        reset_dut();
        I = 8'h01;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input Bit 1 active (I=8'h02)", test_num);
        reset_dut();
        I = 8'h02;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input Bit 3 active (I=8'h08)", test_num);
        reset_dut();
        I = 8'h08;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input Bit 7 active (I=8'h80)", test_num);
        reset_dut();
        I = 8'h80;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Bit 7 and 0 active)", test_num);
        reset_dut();
        I = 8'h81;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Bits 5, 4, 3 active)", test_num);
        reset_dut();
        I = 8'h38;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Bits 1 and 2 active)", test_num);
        reset_dut();
        I = 8'h06;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits active (I=8'hFF)", test_num);
        reset_dut();
        I = 8'hFF;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs inactive (I=8'h00)", test_num);
        reset_dut();
        I = 8'h00;
        @(posedge EN);
        #2;

        #1;


        check_outputs(3'b100);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Bit 4 active", test_num);
        reset_dut();
        I = 8'h10;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Any Active bit", test_num);
        reset_dut();
        I = 8'h04;
        @(posedge EN);
        #2;

        #1;


        check_outputs(3'b010);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Bits 6 and 5)", test_num);
        reset_dut();
        I = 8'h60;
        @(posedge EN);
        #2;
        #1;

        check_outputs(3'b110);
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
        input [2:0] expected_Y;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,EN, I, Y);
    end

endmodule
