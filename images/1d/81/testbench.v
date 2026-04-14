`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] phase_control;
    wire phase_shifted_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .clk(clk),
        .phase_control(phase_control),
        .phase_shifted_clk(phase_shifted_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting/Initializing DUT...");
            phase_control = 2'b00;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 0 Degree Phase Shift (0°)", test_num);
            reset_dut();

            phase_control = 2'b00;
            #50;



            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 90 Degree Phase Shift (90°)", test_num);
            reset_dut();

            phase_control = 2'b01;
            #50;



            @(posedge clk);
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 180 Degree Phase Shift (180°)", test_num);
            reset_dut();

            phase_control = 2'b10;
            #50;



            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 270 Degree Phase Shift (270°)", test_num);
            reset_dut();

            phase_control = 2'b11;
            #50;



            @(posedge clk);
            #8.5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Switching from 0 to 180 and checking stability", test_num);
            reset_dut();

            phase_control = 2'b00;
            #20;
            phase_control = 2'b10;
            #50;


            @(posedge clk);
            #2;
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
        input expected_phase_shifted_clk;
        begin
            if (expected_phase_shifted_clk === (expected_phase_shifted_clk ^ phase_shifted_clk ^ expected_phase_shifted_clk)) begin
                $display("PASS");
                $display("  Outputs: phase_shifted_clk=%b",
                         phase_shifted_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_shifted_clk=%b",
                         expected_phase_shifted_clk);
                $display("  Got:      phase_shifted_clk=%b",
                         phase_shifted_clk);
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
        $dumpvars(0,clk, phase_control, phase_shifted_clk);
    end

endmodule
