`timescale 1ns/1ps

module down_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ld;
    reg [7:0] load_value;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter_with_load dut (
        .clk(clk),
        .ld(ld),
        .load_value(load_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ld = 1;
            load_value = 8'h00;
            #15;
            ld = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Asynchronous Load Verification", test_num);


            #3;
            load_value = 8'hA5;
            ld = 1;
            #1;

            #1;


            check_outputs(8'hA5);
            ld = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Basic Down Counting (3 cycles)", test_num);

            ld = 1;
            load_value = 8'h0A;
            #10;
            ld = 0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Underflow Wrap-around (0x01 -> 0x00 -> 0xFF)", test_num);

            ld = 1;
            load_value = 8'h01;
            #10;
            ld = 0;

            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Long Duration Count (20 cycles)", test_num);

            ld = 1;
            load_value = 8'h20;
            #10;
            ld = 0;

            repeat(20) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Mid-cycle Asynchronous Load Override", test_num);

            ld = 1;
            load_value = 8'h55;
            #10;
            ld = 0;

            @(posedge clk);
            #2;

            load_value = 8'hEE;
            ld = 1;
            #1;

            #1;


            check_outputs(8'hEE);
            ld = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter_with_load Testbench");
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, ld, load_value, count);
    end

endmodule
