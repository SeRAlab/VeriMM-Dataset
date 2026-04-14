`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    wire shifted_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .control(control),
        .shifted_signal(shifted_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 2'b00;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: 0-Degree Shift - Expect High", test_num);
            control = 2'b00;
            repeat(2) @(posedge clk);
            #2.5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: 90-Degree Shift - Expect High", test_num);
            control = 2'b01;
            repeat(2) @(posedge clk);
            #5.0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: 180-Degree Shift - Expect High", test_num);
            control = 2'b10;
            repeat(2) @(posedge clk);
            #7.5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: 270-Degree Shift - Expect High", test_num);
            control = 2'b11;
            repeat(2) @(posedge clk);
            #9.5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: 0-Degree Shift - Expect Low", test_num);
            control = 2'b00;
            repeat(2) @(posedge clk);
            #7.5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: 90-Degree Shift - Expect Low", test_num);
            control = 2'b01;
            repeat(2) @(posedge clk);
            #1.0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: 180-Degree Shift - Expect Low", test_num);
            control = 2'b10;
            repeat(2) @(posedge clk);
            #2.5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: 270-Degree Shift - Expect Low", test_num);
            control = 2'b11;
            repeat(2) @(posedge clk);
            #5.0;
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
        $display("phase_shifter Testbench");
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
        input expected_shifted_signal;
        begin
            if (expected_shifted_signal === (expected_shifted_signal ^ shifted_signal ^ expected_shifted_signal)) begin
                $display("PASS");
                $display("  Outputs: shifted_signal=%b",
                         shifted_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_signal=%b",
                         expected_shifted_signal);
                $display("  Got:      shifted_signal=%b",
                         shifted_signal);
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
        $dumpvars(0,clk, control, shifted_signal);
    end

endmodule
