`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg SCL;
    reg SDA_in;
    reg start;
    reg stop;
    wire [7:0] data_out;
    wire start_condition;
    wire stop_condition;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .SCL(SCL),
        .SDA_in(SDA_in),
        .start(start),
        .stop(stop),
        .data_out(data_out),
        .start_condition(start_condition),
        .stop_condition(stop_condition)
    );

    // Clock generation (10ns period)
    initial begin
        SCL = 0;
        forever #5 SCL = ~SCL;
    end

        task reset_dut;

        begin
            SDA_in = 1;
            start = 0;
            stop = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Start Condition Detection", test_num);
            reset_dut();

            @(negedge SCL);
            SDA_in = 1;
            start = 1;
            @(posedge SCL);
            #2;
            SDA_in = 0;
            #10;

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Stop Condition Detection", test_num);
            reset_dut();

            @(negedge SCL);
            SDA_in = 0;
            stop = 1;
            @(posedge SCL);
            #2;
            SDA_in = 1;
            #10;

            #1;


            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        reg [7:0] test_data;
        integer i;
        begin
            test_num = 3;
            test_data = 8'hAA;
            $display("\nTestcase %0d: Send Data Byte 0x%h", test_num, test_data);
            reset_dut();

            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge SCL);
                SDA_in = test_data[i];
            end

            @(posedge SCL);
            #5;
            #1;

            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        reg [7:0] test_data;
        integer i;
        begin
            test_num = 4;
            test_data = 8'h55;
            $display("\nTestcase %0d: Send Data Byte 0x%h", test_num, test_data);
            reset_dut();

            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge SCL);
                SDA_in = test_data[i];
            end

            @(posedge SCL);
            #5;
            #1;

            check_outputs(8'h55, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        reg [7:0] test_data;
        integer i;
        begin
            test_num = 5;
            test_data = 8'hF0;
            $display("\nTestcase %0d: Sequence Start -> 0x%h -> Stop", test_num, test_data);
            reset_dut();


            @(negedge SCL);
            SDA_in = 1;
            @(posedge SCL);
            #2; SDA_in = 0;
            #5;


            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge SCL);
                SDA_in = test_data[i];
            end


            @(negedge SCL);
            SDA_in = 0;
            @(posedge SCL);
            #2; SDA_in = 1;
            #10;

            #1;


            check_outputs(8'hF0, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_start_condition;
        input expected_stop_condition;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_start_condition === (expected_start_condition ^ start_condition ^ expected_start_condition) &&
                expected_stop_condition === (expected_stop_condition ^ stop_condition ^ expected_stop_condition)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, start_condition=%b, stop_condition=%b",
                         data_out, start_condition, stop_condition);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, start_condition=%b, stop_condition=%b",
                         expected_data_out, expected_start_condition, expected_stop_condition);
                $display("  Got:      data_out=%h, start_condition=%b, stop_condition=%b",
                         data_out, start_condition, stop_condition);
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
        $dumpvars(0,SCL, SDA_in, start, stop, data_out, start_condition, stop_condition);
    end

endmodule
