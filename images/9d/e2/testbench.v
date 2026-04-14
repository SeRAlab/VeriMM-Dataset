`timescale 1ns/1ps

module enable_load_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg enable;
    reg load;
    reg rst_n;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    enable_load_counter dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            load = 0;
            data = 4'b0000;
            @(posedge clk);
            #1 rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Verifying Load Functionality", test_num);
            reset_dut();
            data = 4'hA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Verifying Simple Increment", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Verifying Counter holds when Enable is Low", test_num);
            reset_dut();
            enable = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verifying Load Priority over Enable", test_num);
            reset_dut();
            data = 4'h5;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0; enable = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Verifying Rollover (F to 0)", test_num);
            reset_dut();
            data = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Verifying Multiple Increments", test_num);
            reset_dut();
            enable = 1;
            repeat(7) @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Verifying Load followed by Increments", test_num);
            reset_dut();
            data = 4'hB;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            repeat(2) @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("enable_load_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, data, enable, load, rst_n, count);
    end

endmodule
