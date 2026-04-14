`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RST;
    reg UP_DOWN;
    wire [2:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .CLK(CLK),
        .EN(EN),
        .RST(RST),
        .UP_DOWN(UP_DOWN),
        .COUNT(COUNT)
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
            UP_DOWN = 0;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge CLK);
            EN = 1; UP_DOWN = 1;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge CLK);
            EN = 1; UP_DOWN = 0;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge CLK);
            EN = 1; UP_DOWN = 1;
            repeat(2) @(posedge CLK);
            @(negedge CLK);
            EN = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge CLK);
            EN = 1; UP_DOWN = 1;
            repeat(9) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge CLK);
            EN = 1; UP_DOWN = 1;
            repeat(5) @(posedge CLK);
            @(negedge CLK);
            UP_DOWN = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge CLK);
            EN = 1; UP_DOWN = 1;
            repeat(4) @(posedge CLK);
            @(negedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
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
        input [2:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, EN, RST, UP_DOWN, COUNT);
    end

endmodule
