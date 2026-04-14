`timescale 1ns/1ps

module register16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg rst_n;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register16 dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
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
            load = 0;
            data_in = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Check Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Load Operation", test_num);
            reset_dut();
            @(posedge clk);
            data_in <= 16'hABCD;
            load <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Load then Hold", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 16'h1234;
            load <= 1;
            @(posedge clk);

            load <= 0;
            data_in <= 16'hFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Load Min and Max Values", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 16'hFFFF;
            load <= 1;
            @(posedge clk);
            #1;

            @(posedge clk);
            data_in <= 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Multiple Sequential Loads", test_num);
            reset_dut();
            load <= 1;
            @(posedge clk);
            data_in <= 16'hAAAA;
            @(posedge clk);
            data_in <= 16'h5555;
            @(posedge clk);
            data_in <= 16'hF0F0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hF0F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Asynchronous Reset Mid-Cycle", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 16'h8888;
            load <= 1;
            @(posedge clk);
            #2;
            rst_n = 0;
            #1;
            #1;

            check_outputs(16'h0000);
            #5;
            rst_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register16 Testbench");
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
        $dumpvars(0,clk, data_in, load, rst_n, data_out);
    end

endmodule
