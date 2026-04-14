`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg UP;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .CLK(CLK),
        .RST(RST),
        .UP(UP),
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
            UP = 0;
            #15;
            RST = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Count Up 3 Cycles", test_num);
            reset_dut();
            @(negedge CLK);
            UP = 1;
            repeat(3) @(posedge CLK);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Up Counter Roll-over (8 Cycles)", test_num);
            reset_dut();
            @(negedge CLK);
            UP = 1;
            repeat(8) @(posedge CLK);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Count Down (Roll-under)", test_num);
            reset_dut();
            @(negedge CLK);
            UP = 0;
            repeat(1) @(posedge CLK);
            #1 #1;
 check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequence Up 5, Down 2", test_num);
            reset_dut();
            @(negedge CLK);
            UP = 1;
            repeat(5) @(posedge CLK);
            @(negedge CLK);
            UP = 0;
            repeat(2) @(posedge CLK);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Down Counter Full Cycle (8 Cycles)", test_num);
            reset_dut();
            @(negedge CLK);
            UP = 0;
            repeat(8) @(posedge CLK);
            #1 #1;
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
        $display("up_down_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [2:0] expected_Q;
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
        $dumpvars(0,CLK, RST, UP, Q);
    end

endmodule
