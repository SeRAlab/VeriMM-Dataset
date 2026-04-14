`timescale 1ns/1ps

module up_down_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DOWN;
    reg RESET;
    reg UP;
    wire [2:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_3bit dut (
        .CLK(CLK),
        .DOWN(DOWN),
        .RESET(RESET),
        .UP(UP),
        .COUNT(COUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        UP = 0;
        DOWN = 0;
        @(posedge CLK);
        #1;
        RESET = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase001: Reset Check");
        reset_dut();
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase002: Simple Increment (0 -> 1)");
        reset_dut();
        UP = 1;
        DOWN = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase003: Simple Decrement (0 -> 7)");
        reset_dut();
        UP = 0;
        DOWN = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase004: Increment Wrap Around (8 cycles)");
        reset_dut();
        UP = 1;
        DOWN = 0;
        repeat(8) @(posedge CLK);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running testcase005: Sequence (Up 3, Down 1 -> 2)");
        reset_dut();
        UP = 1;
        repeat(3) @(posedge CLK);
        UP = 0;
        DOWN = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running testcase006: Hold Value");
        reset_dut();
        UP = 1;
        repeat(4) @(posedge CLK);
        UP = 0;
        DOWN = 0;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running testcase007: Simultaneous UP and DOWN");
        reset_dut();
        UP = 1;
        DOWN = 1;
        @(posedge CLK);
        #1;


        #1;



        check_outputs(3'b001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_3bit Testbench");
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
        $dumpvars(0,CLK, DOWN, RESET, UP, COUNT);
    end

endmodule
