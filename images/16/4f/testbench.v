`timescale 1ns/1ps

module carrier_freq_recovery_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg digital_signal;
    reg rst;
    wire recovered_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carrier_freq_recovery dut (
        .clk(clk),
        .digital_signal(digital_signal),
        .rst(rst),
        .recovered_signal(recovered_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            digital_signal = 0;
            #(CLK_PERIOD * 5);
            rst = 0;
            #(CLK_PERIOD * 2);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset and Idle State", test_num);
            reset_dut();


            #(CLK_PERIOD * 20);



            #1;




            check_outputs(recovered_signal);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Tracking 25MHz Signal (Period 40ns)", test_num);
            reset_dut();


            for (i = 0; i < 25; i = i + 1) begin
                digital_signal = 1; #20;
                digital_signal = 0; #20;
            end



            #1;




            check_outputs(recovered_signal);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Tracking 10MHz Signal (Period 100ns)", test_num);
            reset_dut();


            for (i = 0; i < 20; i = i + 1) begin
                digital_signal = 1; #50;
                digital_signal = 0; #50;
            end


            #1;



            check_outputs(recovered_signal);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Signal Interruption and Re-acquisition", test_num);
            reset_dut();


            for (i = 0; i < 15; i = i + 1) begin
                digital_signal = 1; #25;
                digital_signal = 0; #25;
            end


            digital_signal = 0;
            #200;


            for (i = 0; i < 15; i = i + 1) begin
                digital_signal = 1; #25;
                digital_signal = 0; #25;
            end

            #1;


            check_outputs(recovered_signal);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carrier_freq_recovery Testbench");
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
        input expected_recovered_signal;
        begin
            if (expected_recovered_signal === (expected_recovered_signal ^ recovered_signal ^ expected_recovered_signal)) begin
                $display("PASS");
                $display("  Outputs: recovered_signal=%b",
                         recovered_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: recovered_signal=%b",
                         expected_recovered_signal);
                $display("  Got:      recovered_signal=%b",
                         recovered_signal);
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
        $dumpvars(0,clk, digital_signal, rst, recovered_signal);
    end

endmodule
