`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] pulse_width;
    reg trigger;
    wire pulse_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .clk(clk),
        .pulse_width(pulse_width),
        .trigger(trigger),
        .pulse_out(pulse_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            trigger = 0;
            pulse_width = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pulse Width 3", test_num);
            reset_dut();

            pulse_width = 4'd3;
            @(posedge clk);
            #1 trigger = 1;
            @(posedge clk);
            #1 trigger = 0;


            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pulse Width 1", test_num);
            reset_dut();

            pulse_width = 4'd1;
            @(posedge clk);
            #1 trigger = 1;
            @(posedge clk);
            #1 trigger = 0;


            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pulse Width 10", test_num);
            reset_dut();

            pulse_width = 4'd10;
            @(posedge clk);
            #1 trigger = 1;
            @(posedge clk);
            #1 trigger = 0;


            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Pulse Width 15", test_num);
            reset_dut();

            pulse_width = 4'd15;
            @(posedge clk);
            #1 trigger = 1;
            @(posedge clk);
            #1 trigger = 0;


            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Consecutive Triggers", test_num);
            reset_dut();


            pulse_width = 4'd2;
            @(posedge clk);
            #1 trigger = 1;
            @(posedge clk);
            #1 trigger = 0;
            repeat(3) @(posedge clk);


            pulse_width = 4'd4;
            @(posedge clk);
            #1 trigger = 1;
            @(posedge clk);
            #1 trigger = 0;
            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sticky Trigger Check", test_num);
            reset_dut();

            pulse_width = 4'd2;
            @(posedge clk);
            #1 trigger = 1;
            repeat(5) @(posedge clk);
            #1 trigger = 0;

            @(posedge clk);
            #1 #1;
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
        input expected_pulse_out;
        begin
            if (expected_pulse_out === (expected_pulse_out ^ pulse_out ^ expected_pulse_out)) begin
                $display("PASS");
                $display("  Outputs: pulse_out=%b",
                         pulse_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse_out=%b",
                         expected_pulse_out);
                $display("  Got:      pulse_out=%b",
                         pulse_out);
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
        $dumpvars(0,clk, pulse_width, trigger, pulse_out);
    end

endmodule
