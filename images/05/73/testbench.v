`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] preset_value;
    reg reset_n;
    wire timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .preset_value(preset_value),
        .reset_n(reset_n),
        .timeout(timeout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;

            @(posedge clk);
            #1 reset_n = 1;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying countdown to timeout with preset 5", test_num);
            preset_value = 4'd5;
            reset_dut();


            repeat(5) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying reset prevents timeout", test_num);
            preset_value = 4'd8;
            reset_dut();


            repeat(4) @(posedge clk);


            reset_n = 0;
            @(posedge clk);
            #1 reset_n = 1;


            repeat(4) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying countdown with a shorter preset (3)", test_num);
            preset_value = 4'd3;
            reset_dut();

            repeat(3) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying timeout persistence", test_num);
            preset_value = 4'd2;
            reset_dut();


            repeat(10) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying reset clears an active timeout", test_num);
            preset_value = 4'd4;
            reset_dut();


            repeat(4) @(posedge clk);
            #2;




            reset_n = 0;
            @(posedge clk);
            #1 reset_n = 1;

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
        $display("watchdog_timer Testbench");
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
        input expected_timeout;
        begin
            if (expected_timeout === (expected_timeout ^ timeout ^ expected_timeout)) begin
                $display("PASS");
                $display("  Outputs: timeout=%b",
                         timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout=%b",
                         expected_timeout);
                $display("  Got:      timeout=%b",
                         timeout);
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
        $dumpvars(0,clk, preset_value, reset_n, timeout);
    end

endmodule
