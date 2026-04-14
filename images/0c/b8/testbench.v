`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            read_enable = 0;
            write_enable = 0;
            data_in = 16'h0000;
            @(posedge clk);

            write_enable = 1;
            data_in = 16'h0000;
            @(posedge clk);
            write_enable = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Basic Write and Read", test_num);


            data_in = 16'hABCD;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;


            read_enable = 1;
            #2;
            #1;

            check_outputs(16'hABCD);
            read_enable = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Data Stability (Write Disable)", test_num);


            data_in = 16'h1234;
            write_enable = 1;
            @(posedge clk);


            write_enable = 0;
            data_in = 16'hFFFF;
            @(posedge clk);


            read_enable = 1;
            #2;
            #1;

            check_outputs(16'h1234);
            read_enable = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Overwriting Data", test_num);


            data_in = 16'hAAAA;
            write_enable = 1;
            @(posedge clk);


            data_in = 16'h5555;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;


            read_enable = 1;
            #2;
            #1;

            check_outputs(16'h5555);
            read_enable = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Read Enable Logic", test_num);

            data_in = 16'h7777;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;


            read_enable = 0;
            #2;


            if (data_out === 16'h7777) begin
                $display("FAIL: Data leaked while read_enable was low");
                fail_count = fail_count + 1;
            end else begin

                read_enable = 1;
                #2;
                #1;

                check_outputs(16'h7777);
            end
            read_enable = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Boundary Values (All 1s)", test_num);

            data_in = 16'hFFFF;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;

            read_enable = 1;
            #2;
            #1;

            check_outputs(16'hFFFF);
            read_enable = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,clk, data_in, read_enable, write_enable, data_out);
    end

endmodule
