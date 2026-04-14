`timescale 1ns/1ps

module temperature_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_temp;
    reg [7:0] recovery_temp;
    reg reset;
    reg [7:0] threshold_temp;
    wire shutdown;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_shutdown dut (
        .clk(clk),
        .current_temp(current_temp),
        .recovery_temp(recovery_temp),
        .reset(reset),
        .threshold_temp(threshold_temp),
        .shutdown(shutdown)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_temp = 0;
            threshold_temp = 80;
            recovery_temp = 60;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Operation", test_num);
            reset_dut();
            current_temp = 25;
            threshold_temp = 80;
            recovery_temp = 60;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Trigger Shutdown", test_num);
            reset_dut();
            current_temp = 85;
            threshold_temp = 80;
            recovery_temp = 60;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Latching Behavior", test_num);
            reset_dut();
            threshold_temp = 80;
            recovery_temp = 60;


            current_temp = 85;
            @(posedge clk);


            current_temp = 70;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery", test_num);
            reset_dut();
            threshold_temp = 80;
            recovery_temp = 60;


            current_temp = 90;
            @(posedge clk);


            current_temp = 55;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during Shutdown", test_num);
            reset_dut();
            threshold_temp = 80;
            recovery_temp = 60;


            current_temp = 95;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Threshold", test_num);
            reset_dut();
            threshold_temp = 80;
            current_temp = 80;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Recovery", test_num);
            reset_dut();
            threshold_temp = 80;
            recovery_temp = 60;


            current_temp = 85;
            @(posedge clk);


            current_temp = 60;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_shutdown Testbench");
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
        input expected_shutdown;
        begin
            if (expected_shutdown === (expected_shutdown ^ shutdown ^ expected_shutdown)) begin
                $display("PASS");
                $display("  Outputs: shutdown=%b",
                         shutdown);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown=%b",
                         expected_shutdown);
                $display("  Got:      shutdown=%b",
                         shutdown);
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
        $dumpvars(0,clk, current_temp, recovery_temp, reset, threshold_temp, shutdown);
    end

endmodule
