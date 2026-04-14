`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load_en;
    reg rst_n;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load_en(load_en),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load_en = 0;
            data_in = 0;

            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Verifying register resets to 0...");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Loading hex value AAAA...");
            reset_dut();
            @(negedge clk);
            data_in = 16'hAAAA;
            load_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Verifying data does not load when load_en is low...");
            reset_dut();

            @(negedge clk);
            data_in = 16'h1234;
            load_en = 1;
            @(posedge clk);

            @(negedge clk);
            data_in = 16'hFFFF;
            load_en = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Loading FFFF...");
            reset_dut();
            @(negedge clk);
            data_in = 16'hFFFF;
            load_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Multiple sequential loads...");
            reset_dut();
            @(negedge clk);
            load_en = 1;
            data_in = 16'h1111;
            @(posedge clk);
            #1;
            data_in = 16'h2222;
            @(posedge clk);
            #1;
            data_in = 16'h3333;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Reset after operation...");
            reset_dut();
            @(negedge clk);
            data_in = 16'hBEEF;
            load_en = 1;
            @(posedge clk);
            #1;

            rst_n = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load_en, rst_n, data_out);
    end

endmodule
