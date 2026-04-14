`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CTRL;
    reg EN;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .CLK(CLK),
        .CTRL(CTRL),
        .EN(EN),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            CTRL = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Increment (Up 10)", test_num);
            reset_dut();
            EN = 1;
            CTRL = 1;
            repeat (10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Decrement (Down 5 from 0)", test_num);
            reset_dut();
            EN = 1;
            CTRL = 0;
            repeat (5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Enable Signal Check (EN=0)", test_num);
            reset_dut();
            EN = 0;
            CTRL = 1;
            repeat (10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Bidirectional (Up 20, Down 5)", test_num);
            reset_dut();
            EN = 1;
            CTRL = 1;
            repeat (20) @(posedge CLK);
            CTRL = 0;
            repeat (5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Full Overflow Wrap (Up 257)", test_num);
            reset_dut();
            EN = 1;
            CTRL = 1;
            repeat (257) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Synchronous Reset Priority", test_num);
            reset_dut();
            EN = 1;
            CTRL = 1;
            repeat (5) @(posedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Pause and Resume (EN toggling)", test_num);
            reset_dut();
            EN = 1;
            CTRL = 1;
            repeat (5) @(posedge CLK);
            EN = 0;
            repeat (5) @(posedge CLK);
            EN = 1;
            repeat (5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, CTRL, EN, RST, Q);
    end

endmodule
