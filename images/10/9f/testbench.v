`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg read_en;
    reg rst;
    reg write_en;
    wire [15:0] data_out;
    wire refresh;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .rst(rst),
        .write_en(write_en),
        .data_out(data_out),
        .refresh(refresh)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_en = 0;
            read_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Write and Read", test_num);
            reset_dut();


            write_en = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            #5;

            #1;


            check_outputs(16'hABCD, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Reset Functionality", test_num);
            reset_dut();


            write_en = 1;
            data_in = 16'h5555;
            @(posedge clk);
            #1 write_en = 0;


            reset_dut();


            read_en = 1;
            #5;

            #1;


            check_outputs(16'h0000, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Refresh Trigger Check", test_num);
            reset_dut();



            repeat (100) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Data Retention through Refresh", test_num);
            reset_dut();


            write_en = 1;
            data_in = 16'hDEAD;
            @(posedge clk);
            #1 write_en = 0;


            repeat (105) @(posedge clk);

            read_en = 1;
            #5;


            #1;



            check_outputs(16'hDEAD, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Asynchronous Read Behavior", test_num);
            reset_dut();

            write_en = 1;
            data_in = 16'h1234;
            @(posedge clk);
            #1 write_en = 0;


            #20;
            read_en = 1;
            #2;

            #1;


            check_outputs(16'h1234, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Multiple Overwrites", test_num);
            reset_dut();

            write_en = 1;
            data_in = 16'hAAAA;
            @(posedge clk);
            #1 data_in = 16'hBBBB;
            @(posedge clk);
            #1 write_en = 0;

            read_en = 1;
            #5;

            #1;


            check_outputs(16'hBBBB, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_refresh;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_refresh === (expected_refresh ^ refresh ^ expected_refresh)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, refresh=%b",
                         data_out, refresh);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, refresh=%b",
                         expected_data_out, expected_refresh);
                $display("  Got:      data_out=%h, refresh=%b",
                         data_out, refresh);
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
        $dumpvars(0,clk, data_in, read_en, rst, write_en, data_out, refresh);
    end

endmodule
