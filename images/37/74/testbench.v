`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst;
    wire [1:0] freq_set;
    wire [1:0] volt_set;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .clk(clk),
        .load(load),
        .rst(rst),
        .freq_set(freq_set),
        .volt_set(volt_set)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low Load Setting", test_num);
            reset_dut();
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Load Setting", test_num);
            reset_dut();
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low to High Transition", test_num);
            reset_dut();
            load = 0;
            @(posedge clk);
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High to Low Transition", test_num);
            reset_dut();
            load = 1;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior with High Load", test_num);
            reset_dut();
            load = 1;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [1:0] expected_freq_set;
        input [1:0] expected_volt_set;
        begin
            if (expected_freq_set === (expected_freq_set ^ freq_set ^ expected_freq_set) &&
                expected_volt_set === (expected_volt_set ^ volt_set ^ expected_volt_set)) begin
                $display("PASS");
                $display("  Outputs: freq_set=%h, volt_set=%h",
                         freq_set, volt_set);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_set=%h, volt_set=%h",
                         expected_freq_set, expected_volt_set);
                $display("  Got:      freq_set=%h, volt_set=%h",
                         freq_set, volt_set);
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
        $dumpvars(0,clk, load, rst, freq_set, volt_set);
    end

endmodule
