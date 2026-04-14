`timescale 1ns/1ps

module parallel_load_register_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data_in;
    reg load;
    reg rst;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_register_12bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .q(q)
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
            data_in = 12'h000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data 12'hABC", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 12'hABC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Data (load=0)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 12'h555;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            data_in = 12'hAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over Load", test_num);
            reset_dut();
            @(negedge clk);
            rst = 1;
            load = 1;
            data_in = 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Boundary Value All 1s", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 12'hFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Loading", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 12'h123;
            @(posedge clk);
            @(negedge clk);
            data_in = 12'h456;
            @(posedge clk);
            @(negedge clk);
            data_in = 12'h789;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h789);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_load_register_12bit Testbench");
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, rst, q);
    end

endmodule
