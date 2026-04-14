`timescale 1ns/1ps

module loadable_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [31:0] load_val;
    reg rst_n;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    loadable_counter dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
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
            $display("Resetting DUT...");
            rst_n = 0;
            load = 0;
            load_val = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Value Check", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 32'hA5A5_5A5A;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Increment Check", test_num);
            reset_dut();

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load then Increment Check", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 32'h0000_00FF;
            @(posedge clk);
            #1 load = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Check (Max to Zero)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 32'hFFFF_FFFF;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous Load Check", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_val = 32'h1234_5678;
            @(posedge clk);
            load_val = 32'h8765_4321;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority Check", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1 load = 1;
            load_val = 32'h0000_CAFE;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'h0000_CAFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Count Check", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd100);
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
        $dumpvars(0,clk, load, load_val, rst_n, count);
    end

endmodule
