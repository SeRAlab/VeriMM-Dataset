`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Verification");
            test_num = 1;
            reset_dut();


            control = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Simple Write and Read (0xA5)");
            test_num = 2;
            reset_dut();


            control = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Overwrite Test (0x55 then 0xAA)");
            test_num = 3;
            reset_dut();


            control = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;


            data_in = 8'hAA;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Data Retention Over Time");
            test_num = 4;
            reset_dut();


            control = 1;
            data_in = 8'hF0;
            @(posedge clk);
            #1;


            control = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Boundary Values (0xFF)");
            test_num = 5;
            reset_dut();


            control = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;


            control = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, control, data_in, reset, data_out);
    end

endmodule
