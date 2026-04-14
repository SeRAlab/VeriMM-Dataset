`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sel;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Input A (Standard Values)", test_num);
        A = 8'hAA;
        B = 8'h55;
        sel = 1'b0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Input B (Standard Values)", test_num);
        A = 8'hAA;
        B = 8'h55;
        sel = 1'b1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Input A (All Zeros)", test_num);
        A = 8'h00;
        B = 8'hFF;
        sel = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Input B (All Ones)", test_num);
        A = 8'h00;
        B = 8'hFF;
        sel = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select Input A (Alternating Bits)", test_num);
        A = 8'b10101010;
        B = 8'b01010101;
        sel = 1'b0;
        #1;

        check_outputs(8'b10101010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select Input B (Large Value)", test_num);
        A = 8'h12;
        B = 8'hE7;
        sel = 1'b1;
        #1;

        check_outputs(8'hE7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Switching select with identical inputs", test_num);
        A = 8'h3C;
        B = 8'h3C;
        sel = 1'b0;
        #5;
        sel = 1'b1;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
