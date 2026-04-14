`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire [7:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            serial_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task drive_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = data[i];
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Driving 8'hFF", test_num);
            reset_dut();
            drive_byte(8'hFF);
            #1 #1;
 check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Driving 8'h00", test_num);
            reset_dut();
            drive_byte(8'h00);
            #1 #1;
 check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Driving 8'hAA", test_num);
            reset_dut();
            drive_byte(8'hAA);
            #1 #1;
 check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Driving 8'h55", test_num);
            reset_dut();
            drive_byte(8'h55);
            #1 #1;
 check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Driving 8'h81", test_num);
            reset_dut();
            drive_byte(8'h81);
            #1 #1;
 check_outputs(8'h81, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Driving 8'h3C", test_num);
            reset_dut();
            drive_byte(8'h3C);
            #1 #1;
 check_outputs(8'h3C, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();
            #1 #1;
 check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase008;

        integer j;
        begin
            test_num = 8;
            $display("Test Case %0d: Partial sequence (4 bits)", test_num);
            reset_dut();

            for (j = 0; j < 4; j = j + 1) begin
                serial_in = 1'b1;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_parallel_out;
        input expected_valid;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, valid=%b",
                         parallel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, valid=%b",
                         expected_parallel_out, expected_valid);
                $display("  Got:      parallel_out=%h, valid=%b",
                         parallel_out, valid);
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
        $dumpvars(0,clk, rst, serial_in, parallel_out, valid);
    end

endmodule
