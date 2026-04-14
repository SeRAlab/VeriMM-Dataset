`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg load;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
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
            enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Synchronous Reset and Idle State", test_num);
            reset_dut();

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Load Operation", test_num);
            reset_dut();
            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Increment Operation (5 steps)", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Load then Increment", test_num);
            reset_dut();
            data_in = 8'h50;
            load = 1;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat(3) @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(8'h53);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Counter Wrap-around", test_num);
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Reset Priority Check", test_num);
            reset_dut();

            enable = 1;
            repeat(2) @(posedge clk);

            reset = 1;
            load = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Load Priority Over Enable", test_num);
            reset_dut();
            data_in = 8'hCC;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1;
            load = 0;
            enable = 0;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("loadable_counter Testbench");
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
        $dumpvars(0,clk, data_in, enable, load, reset, count);
    end

endmodule
