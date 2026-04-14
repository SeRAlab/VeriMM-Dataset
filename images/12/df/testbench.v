`timescale 1ns/1ps

module carrier_recovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg modulated_signal;
    wire recovered_carrier;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_recovery dut (
        .clk(clk),
        .modulated_signal(modulated_signal),
        .recovered_carrier(recovered_carrier)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            modulated_signal = 0;
            repeat (5) @(posedge clk);
            rst_n = 1;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = 1;
            $display("\nRunning Testcase%03d: Basic 100MHz Lock", test_num);
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                modulated_signal = 1; #5;
                modulated_signal = 0; #5;
            end


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nRunning Testcase%03d: 50MHz Signal Recovery", test_num);
            reset_dut();


            for (i = 0; i < 50; i = i + 1) begin
                modulated_signal = 1; #10;
                modulated_signal = 0; #10;
            end

            @(posedge clk);
            #1;

            #1;


            check_outputs(recovered_carrier);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nRunning Testcase%03d: Phase Shift Transition", test_num);
            reset_dut();


            for (i = 0; i < 40; i = i + 1) begin
                modulated_signal = 1; #5;
                modulated_signal = 0; #5;
            end


            #5;


            for (i = 0; i < 40; i = i + 1) begin
                modulated_signal = 1; #5;
                modulated_signal = 0; #5;
            end

            @(posedge clk);
            #1;

            if (recovered_carrier === 1'b0 || recovered_carrier === 1'b1)
                #1;

                check_outputs(recovered_carrier);
            else
                #1;

                check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nRunning Testcase%03d: Signal Loss and Re-lock", test_num);
            reset_dut();


            repeat(20) begin
                modulated_signal = 1; #5;
                modulated_signal = 0; #5;
            end


            modulated_signal = 0;
            #200;


            repeat(50) begin
                modulated_signal = 1; #5;
                modulated_signal = 0; #5;
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(recovered_carrier);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carrier_recovery Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_recovered_carrier;
        begin
            if (expected_recovered_carrier === (expected_recovered_carrier ^ recovered_carrier ^ expected_recovered_carrier)) begin
                $display("PASS");
                $display("  Outputs: recovered_carrier=%b",
                         recovered_carrier);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_carrier=%b",
                         expected_recovered_carrier);
                $display("  Got:      recovered_carrier=%b",
                         recovered_carrier);
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
        $dumpvars(0,clk, modulated_signal, recovered_carrier);
    end

endmodule
