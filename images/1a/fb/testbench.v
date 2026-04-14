`timescale 1ns/1ps

module up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [31:0] load_value;
    reg reset;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter dut (
        .clk(clk),
        .enable(enable),
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
            reset <= 1;
            enable <= 0;
            load <= 0;
            load_value <= 0;
            @(posedge clk);
            reset <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Counting (5 steps)", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            wait_cycles(5);
            enable <= 0;
            #1;

            check_outputs(32'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Specific Value", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            load_value <= 32'hA5A5A5A5;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load then Count 3 steps", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            load_value <= 32'h0000FFFE;
            @(posedge clk);
            load <= 0;
            enable <= 1;
            wait_cycles(3);
            enable <= 0;

            #1;


            check_outputs(32'h00010001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Low (Pause) Check", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            wait_cycles(3);
            enable <= 0;
            wait_cycles(5);
            #1;

            check_outputs(32'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Rollover (FFFFFFFF -> 0)", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            load_value <= 32'hFFFFFFFF;
            @(posedge clk);
            load <= 0;
            enable <= 1;
            @(posedge clk);
            enable <= 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority Check", test_num);
            reset_dut();
            @(posedge clk);
            enable <= 1;
            load <= 1;
            load_value <= 32'h12345678;
            reset <= 1;
            @(posedge clk);
            reset <= 0;
            load <= 0;
            enable <= 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter Testbench");
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
        input [31:0] expected_count;
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
        $dumpvars(0,clk, enable, load, load_value, reset, count);
    end

endmodule
