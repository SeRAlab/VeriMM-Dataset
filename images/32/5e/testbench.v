`timescale 1ns/1ps

module rc_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] capacitor_value;
    reg clk;
    reg [7:0] resistor_value;
    wire oscillator_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rc_oscillator dut (
        .capacitor_value(capacitor_value),
        .clk(clk),
        .resistor_value(resistor_value),
        .oscillator_out(oscillator_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting circuit...");
            resistor_value = 0;
            capacitor_value = 0;

            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small R, C values", test_num);
            reset_dut();

            resistor_value = 8'd5;
            capacitor_value = 8'd2;


            repeat (11) @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full cycle check", test_num);
            reset_dut();

            resistor_value = 8'd4;
            capacitor_value = 8'd3;


            repeat (25) @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger R, C values", test_num);
            reset_dut();

            resistor_value = 8'd20;
            capacitor_value = 8'd10;

            repeat (201) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range values", test_num);
            reset_dut();

            resistor_value = 8'd50;
            capacitor_value = 8'd2;

            repeat (101) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum non-zero values", test_num);
            reset_dut();

            resistor_value = 8'd1;
            capacitor_value = 8'd1;

            repeat (2) @(posedge clk);


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
        $display("rc_oscillator Testbench");
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
        input expected_oscillator_out;
        begin
            if (expected_oscillator_out === (expected_oscillator_out ^ oscillator_out ^ expected_oscillator_out)) begin
                $display("PASS");
                $display("  Outputs: oscillator_out=%b",
                         oscillator_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oscillator_out=%b",
                         expected_oscillator_out);
                $display("  Got:      oscillator_out=%b",
                         oscillator_out);
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
        $dumpvars(0,capacitor_value, clk, resistor_value, oscillator_out);
    end

endmodule
