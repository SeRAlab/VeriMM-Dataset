`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg activate;
    reg clk;
    reg reset;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .activate(activate),
        .clk(clk),
        .reset(reset),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            activate = 0;
            reset = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            activate <= 1;
            @(posedge clk);
            activate <= 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying pulse starts high after activation", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            activate <= 1;
            @(posedge clk);
            activate <= 0;
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying pulse remains high during cycle 5", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            activate <= 1;
            @(posedge clk);
            activate <= 0;
            repeat(6) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying pulse goes low after exactly 5 cycles", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            activate <= 1;
            @(posedge clk);
            activate <= 0;
            repeat(2) @(posedge clk);
            reset <= 1;
            #5;
            $display("Testcase %0d: Verifying reset forces pulse low mid-operation", test_num);
            #1;

            check_outputs(1'b0);
            #5;
            reset <= 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            activate <= 1;
            @(posedge clk);
            activate <= 0;
            repeat(3) @(posedge clk);
            activate <= 1;
            @(posedge clk);
            activate <= 0;
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase %0d: Verifying pulse is high after re-triggering mid-pulse", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clk);
            activate <= 1;
            repeat(10) @(posedge clk);
            #1;



            $display("Testcase %0d: Verifying output behavior with long activation signal", test_num);

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
        $dumpvars(0,activate, clk, reset, pulse);
    end

endmodule
