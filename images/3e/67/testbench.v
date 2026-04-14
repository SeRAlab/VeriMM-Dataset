`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] init_value;
    reg load;
    reg rst_n;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .init_value(init_value),
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
            load = 0;
            init_value = 5'd0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load and Decrement", test_num);
            reset_dut();


            init_value = 5'd15;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around Check", test_num);
            reset_dut();


            init_value = 5'd2;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Value Check", test_num);
            reset_dut();

            init_value = 5'd31;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority Check", test_num);
            reset_dut();

            load = 1;
            init_value = 5'd20;
            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);


            rst_n = 1;
            load = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous Count From Zero", test_num);
            reset_dut();


            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd29);
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
        input [4:0] expected_count;
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
        $dumpvars(0,clk, init_value, load, rst_n, count);
    end

endmodule
