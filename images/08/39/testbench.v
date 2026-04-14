`timescale 1ns/1ps

module CarrierFrequencyRecovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg modulated_signal;
    reg reset;
    wire carrier_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CarrierFrequencyRecovery dut (
        .clk(clk),
        .modulated_signal(modulated_signal),
        .reset(reset),
        .carrier_signal(carrier_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            modulated_signal = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Single 0->1 transition", test_num);
            reset_dut();

            @(posedge clk);
            #1 modulated_signal = 1;

            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Double transition (0->1->0)", test_num);
            reset_dut();


            @(posedge clk);
            #1 modulated_signal = 1;
            repeat (4) @(posedge clk);


            #1 modulated_signal = 0;
            repeat (4) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: No transitions", test_num);
            reset_dut();

            modulated_signal = 0;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Five transitions", test_num);
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                #1 modulated_signal = ~modulated_signal;
                repeat (3) @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Rapid transitions", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                #1 modulated_signal = ~modulated_signal;
                @(posedge clk);
            end


            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset_dut();


            repeat (3) begin
                @(posedge clk);
                #1 modulated_signal = ~modulated_signal;
                repeat (2) @(posedge clk);
            end


            #1 reset = 1;
            repeat (2) @(posedge clk);
            #1 reset = 0;

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
        $display("CarrierFrequencyRecovery Testbench");
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
        input expected_carrier_signal;
        begin
            if (expected_carrier_signal === (expected_carrier_signal ^ carrier_signal ^ expected_carrier_signal)) begin
                $display("PASS");
                $display("  Outputs: carrier_signal=%b",
                         carrier_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carrier_signal=%b",
                         expected_carrier_signal);
                $display("  Got:      carrier_signal=%b",
                         carrier_signal);
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
        $dumpvars(0,clk, modulated_signal, reset, carrier_signal);
    end

endmodule
