`timescale 1ns/1ps

module counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [5:0] load_value;
    wire [5:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_with_load dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_value(load_value),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting circuit...");
            @(posedge clk);
            load = 1;
            load_value = 6'b0;
            enable = 0;
            @(posedge clk);
            load = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load a specific value", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            load_value = 6'd42;
            @(posedge clk);
            load = 0;
            #1;

            #1;


            check_outputs(6'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic counting (incrementing)", test_num);
            reset_dut();

            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load a value then increment", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            load_value = 6'd10;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(6'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Disable enable (Hold current value)", test_num);
            reset_dut();


            @(posedge clk);
            load = 1;
            load_value = 6'd20;
            @(posedge clk);
            load = 0;


            enable = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(6'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Rollover from 63 to 0", test_num);
            reset_dut();


            @(posedge clk);
            load = 1;
            load_value = 6'd63;
            @(posedge clk);
            load = 0;


            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Load takes priority over Enable", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            load_value = 6'd15;
            enable = 1;
            @(posedge clk);
            load = 0;
            enable = 0;
            #1;


            #1;



            check_outputs(6'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Continuous counting across several cycles", test_num);
            reset_dut();

            enable = 1;
            repeat(20) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(6'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_with_load Testbench");
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
        input [5:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clk, enable, load, load_value, count_out);
    end

endmodule
