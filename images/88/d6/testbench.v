`timescale 1ns/1ps

module parallel_to_serial_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_data;
    reg rst_n;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial dut (
        .clk(clk),
        .load(load),
        .parallel_data(parallel_data),
        .rst_n(rst_n),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            load = 1'b0;
            parallel_data = 16'h0000;
            @(posedge clk);
            #1 rst_n = 1'b1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg [15:0] data_to_load;
        begin
            $display("\nRunning testcase002: All 1s (16'hFFFF)");
            reset_dut();
            data_to_load = 16'hFFFF;


            parallel_data = data_to_load;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;


            for (i = 0; i < 16; i = i + 1) begin
                $display("Checking bit %0d...", i);
                #1;

                check_outputs(data_to_load[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [15:0] data_to_load;
        begin
            $display("\nRunning testcase003: Alternating Pattern (16'hAAAA)");
            reset_dut();
            data_to_load = 16'hAAAA;

            parallel_data = data_to_load;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;

            for (i = 0; i < 16; i = i + 1) begin
                $display("Checking bit %0d...", i);
                #1;

                check_outputs(data_to_load[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [15:0] data_to_load;
        begin
            $display("\nRunning testcase004: Single LSB Bit (16'h0001)");
            reset_dut();
            data_to_load = 16'h0001;

            parallel_data = data_to_load;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;

            for (i = 0; i < 16; i = i + 1) begin
                $display("Checking bit %0d...", i);
                #1;

                check_outputs(data_to_load[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [15:0] data_to_load;
        begin
            $display("\nRunning testcase005: Single MSB Bit (16'h8000)");
            reset_dut();
            data_to_load = 16'h8000;

            parallel_data = data_to_load;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;

            for (i = 0; i < 16; i = i + 1) begin
                $display("Checking bit %0d...", i);
                #1;

                check_outputs(data_to_load[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_to_serial Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, load, parallel_data, rst_n, serial_out);
    end

endmodule
