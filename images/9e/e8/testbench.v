`timescale 1ns/1ps

module parallel_load_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] data;
    reg load;
    reg rst_n;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_register dut (
        .clk(clk),
        .data(data),
        .load(load),
        .rst_n(rst_n),
        .q(q)
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
            data = 6'b0;
            #12;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Loading 6'h2A (101010) into register...", test_num);
            reset_dut();
            @(posedge clk);
            data <= 6'h2A;
            load <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying data retention when load is low...", test_num);
            reset_dut();

            @(posedge clk);
            data <= 6'h15;
            load <= 1;
            @(posedge clk);

            load <= 0;
            data <= 6'h3F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying asynchronous reset priority...", test_num);
            reset_dut();

            @(posedge clk);
            data <= 6'h3F;
            load <= 1;

            #3;
            rst_n = 0;
            #2;

            #1;


            check_outputs(6'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Loading maximum value (6'h3F)...", test_num);
            reset_dut();
            @(posedge clk);
            data <= 6'h3F;
            load <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Performing multiple sequential loads...", test_num);
            reset_dut();
            @(posedge clk);
            load <= 1;
            data <= 6'h01;
            @(posedge clk);
            data <= 6'h02;
            @(posedge clk);
            data <= 6'h04;
            @(posedge clk);
            data <= 6'h08;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_load_register Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, data, load, rst_n, q);
    end

endmodule
