`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [11:0] load_value;
    reg rst;
    wire [11:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_value(load_value),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            load = 0;
            load_value = 0;
            #15;
            rst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Load", test_num);
            reset_dut();

            load_value = 12'hABC;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Down Counting", test_num);
            reset_dut();


            load_value = 12'd10;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            en = 1;
            repeat (5) @(posedge clk);
            #1;
            en = 0;


            #1;



            check_outputs(12'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Signal Control", test_num);
            reset_dut();


            load_value = 12'd20;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            en = 1;
            repeat (3) @(posedge clk);
            #1;

            en = 0;
            repeat (4) @(posedge clk);
            #1;


            #1;



            check_outputs(12'h011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counter Rollover", test_num);
            reset_dut();


            load_value = 12'd1;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            en = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            en = 0;

            #1;


            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Priority", test_num);
            reset_dut();


            load_value = 12'h100;
            load = 1;
            @(posedge clk);
            #1;



            load_value = 12'h555;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(12'h555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Async Reset Mid-Count", test_num);
            reset_dut();

            load_value = 12'hFFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            repeat (10) @(posedge clk);


            #3 rst = 0;
            #10;

            #1;


            check_outputs(12'h000);
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
        input [11:0] expected_count;
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
        $dumpvars(0,clk, en, load, load_value, rst, count);
    end

endmodule
