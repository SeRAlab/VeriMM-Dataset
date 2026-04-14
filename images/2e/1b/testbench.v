`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_value;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            load_value = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Reset State", test_num);
            reset_dut();


            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load value and decrement once", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 8'h0A;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count down to zero and stop", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 8'h03;
            @(posedge clk);
            load = 0;




            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reload during countdown", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 8'h20;
            @(posedge clk);
            load = 0;
            repeat(5) @(posedge clk);
            load = 1;
            load_value = 8'h05;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load zero immediately", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 8'h00;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Countdown from MAX (255)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 8'hFF;
            @(posedge clk);
            load = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(8'hF5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        $dumpvars(0,clk, load, load_value, reset, count);
    end

endmodule
