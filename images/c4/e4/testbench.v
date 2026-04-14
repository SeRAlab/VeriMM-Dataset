`timescale 1ns/1ps

module counter_tb;

    // Testbench signals (sequential circuit)
    reg aclk;
    reg enable;
    reg reset;
    wire [7:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter dut (
        .aclk(aclk),
        .enable(enable),
        .reset(reset),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            @(posedge aclk);
            reset <= 1;
            enable <= 0;
            @(posedge aclk);
            reset <= 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Increment 10 cycles", test_num);
            reset_dut();
            enable <= 1;
            repeat(10) @(posedge aclk);
            enable <= 0;
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Intermittent Enable", test_num);
            reset_dut();
            enable <= 1;
            repeat(5) @(posedge aclk);
            enable <= 0;
            repeat(5) @(posedge aclk);
            enable <= 1;
            repeat(5) @(posedge aclk);
            enable <= 0;
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Overflow Wrap-around", test_num);
            reset_dut();
            enable <= 1;
            repeat(256) @(posedge aclk);
            enable <= 0;
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset Priority", test_num);
            reset_dut();
            enable <= 1;
            repeat(5) @(posedge aclk);
            reset <= 1;
            @(posedge aclk);
            reset <= 0;
            enable <= 0;
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Count to 255", test_num);
            reset_dut();
            enable <= 1;
            repeat(255) @(posedge aclk);
            enable <= 0;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter Testbench");
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
        input [7:0] expected_counter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h",
                         counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h",
                         expected_counter_out);
                $display("  Got:      counter_out=%h",
                         counter_out);
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
        $dumpvars(0,aclk, enable, reset, counter_out);
    end

endmodule
