`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;


        integer i;
        reg [7:0] data;
        begin
            data = 8'hAA;
            $display("\nRunning testcase001: Loading %b", data);
            reset_dut();
            parallel_in = data;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                $display("  Checking bit %0d (Expected: %b)", i, data[i]);
                #1;

                check_outputs(data[i]);
                @(posedge clk);
                #1;
            end

            $display("  Checking Idle state (Expected: 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;


        integer i;
        reg [7:0] data;
        begin
            data = 8'h55;
            $display("\nRunning testcase002: Loading %b", data);
            reset_dut();
            parallel_in = data;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                $display("  Checking bit %0d (Expected: %b)", i, data[i]);
                #1;

                check_outputs(data[i]);
                @(posedge clk);
                #1;
            end
            $display("  Checking Idle state (Expected: 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;


        integer i;
        reg [7:0] data;
        begin
            data = 8'hFF;
            $display("\nRunning testcase003: Loading %b", data);
            reset_dut();
            parallel_in = data;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                $display("  Checking bit %0d (Expected: %b)", i, data[i]);
                #1;

                check_outputs(data[i]);
                @(posedge clk);
                #1;
            end
            $display("  Checking Idle state (Expected: 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;


        integer i;
        reg [7:0] data;
        begin
            data = 8'h00;
            $display("\nRunning testcase004: Loading %b", data);
            reset_dut();
            parallel_in = data;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                $display("  Checking bit %0d (Expected: %b)", i, data[i]);
                #1;

                check_outputs(data[i]);
                @(posedge clk);
                #1;
            end
            $display("  Checking Idle state (Expected: 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;


        integer i;
        reg [7:0] data;
        begin
            data = 8'h81;
            $display("\nRunning testcase005: Loading %b", data);
            reset_dut();
            parallel_in = data;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                $display("  Checking bit %0d (Expected: %b)", i, data[i]);
                #1;

                check_outputs(data[i]);
                @(posedge clk);
                #1;
            end
            $display("  Checking Idle state (Expected: 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        $dumpvars(0,clk, load, parallel_in, reset, serial_out);
    end

endmodule
