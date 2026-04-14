`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] pulse_width;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .clk(clk),
        .enable(enable),
        .pulse_width(pulse_width),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        pulse_width = 0;

        repeat(5) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Width 3 - Checking pulse is HIGH during duration", test_num);
        reset_dut();
        pulse_width = 3;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;

        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Width 3 - Checking pulse returns to LOW after duration", test_num);
        reset_dut();
        pulse_width = 3;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;

        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Width 1 (Minimum) - Checking pulse is HIGH", test_num);
        reset_dut();
        pulse_width = 1;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Width 1 (Minimum) - Checking pulse returns to LOW", test_num);
        reset_dut();
        pulse_width = 1;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Width 10 - Checking mid-point of long pulse", test_num);
        reset_dut();
        pulse_width = 10;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Width 10 - Checking completion of long pulse", test_num);
        reset_dut();
        pulse_width = 10;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Width 15 - Checking pulse is HIGH near end", test_num);
        reset_dut();
        pulse_width = 15;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        repeat(14) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Width 15 - Checking pulse is LOW after completion", test_num);
        reset_dut();
        pulse_width = 15;
        enable = 1;
        @(posedge clk);
        #1;
        enable = 0;
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pulse_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_pulse;
        begin
            if (expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: pulse=%b",
                         pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse=%b",
                         expected_pulse);
                $display("  Got:      pulse=%b",
                         pulse);
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
        $dumpvars(0,clk, enable, pulse_width, pulse);
    end

endmodule
