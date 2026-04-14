`timescale 1ns/1ps

module sync_counter_12bit_load_tb;

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
    sync_counter_12bit_load dut (
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
            @(posedge clk);
            rst = 1;
            en = 0;
            load = 0;
            load_value = 0;
            @(posedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Parallel Load", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'hABC;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Normal Counting", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            en = 0;
            #1;

            check_outputs(12'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable/Disable Functionality", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(12'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Counter Wrap-around", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'hFFF;
            @(posedge clk);
            load = 0;
            en = 1;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();
            @(posedge clk);
            rst = 1;
            load = 1;
            load_value = 12'h555;
            en = 1;
            @(posedge clk);
            rst = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Load Priority", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            repeat(2) @(posedge clk);
            load = 1;
            load_value = 12'h123;
            @(posedge clk);
            load = 0;
            en = 0;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Large Sequence Counting", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 12'd1000;
            @(posedge clk);
            load = 0;
            en = 1;
            repeat(1000) @(posedge clk);
            en = 0;
            #1;

            check_outputs(12'd2000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter_12bit_load Testbench");
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
