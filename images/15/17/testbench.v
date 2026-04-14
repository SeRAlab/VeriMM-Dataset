`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg start;
    wire done;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .done(done),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            reset_dut();
            pattern = 8'b10101010;
            data_in = pattern;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            $display("Testcase001: Shifting 8'b10101010 (LSB first)");
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs((i == 7), pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            reset_dut();
            pattern = 8'b11110000;
            data_in = pattern;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            $display("Testcase002: Shifting 8'b11110000 (LSB first)");
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs((i == 7), pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            reset_dut();
            pattern = 8'h01;
            data_in = pattern;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            $display("Testcase003: Shifting 8'h01");
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs((i == 7), pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            reset_dut();
            pattern = 8'h80;
            data_in = pattern;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            $display("Testcase004: Shifting 8'h80");
            for (i = 0; i < 8; i = i + 1) begin
                #1;

                check_outputs((i == 7), pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase005: Idle State Check");


            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(done, serial_out);
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
        input expected_done;
        input expected_serial_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, serial_out=%b",
                         done, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, serial_out=%b",
                         expected_done, expected_serial_out);
                $display("  Got:      done=%b, serial_out=%b",
                         done, serial_out);
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
        $dumpvars(0,clk, data_in, start, done, serial_out);
    end

endmodule
