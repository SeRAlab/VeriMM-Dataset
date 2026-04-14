`timescale 1ns/1ps

module deserializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] serial_in;
    wire data_ready;
    wire [31:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_32bit dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .data_ready(data_ready),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            serial_in = 8'h0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential pattern 0x01020304", test_num);
            reset_dut();


            serial_in = 8'h01;
            @(negedge clk);

            serial_in = 8'h02;
            @(negedge clk);

            serial_in = 8'h03;
            @(negedge clk);

            serial_in = 8'h04;
            @(negedge clk);


            #1;



            check_outputs(1'b1, 32'h01020304);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones 0xFFFFFFFF", test_num);
            reset_dut();

            serial_in = 8'hFF;
            @(negedge clk);
            serial_in = 8'hFF;
            @(negedge clk);
            serial_in = 8'hFF;
            @(negedge clk);
            serial_in = 8'hFF;
            @(negedge clk);

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros 0x00000000", test_num);
            reset_dut();

            serial_in = 8'h00;
            @(negedge clk);
            serial_in = 8'h00;
            @(negedge clk);
            serial_in = 8'h00;
            @(negedge clk);
            serial_in = 8'h00;
            @(negedge clk);

            #1;


            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern 0xAA55AA55", test_num);
            reset_dut();

            serial_in = 8'hAA;
            @(negedge clk);
            serial_in = 8'h55;
            @(negedge clk);
            serial_in = 8'hAA;
            @(negedge clk);
            serial_in = 8'h55;
            @(negedge clk);

            #1;


            check_outputs(1'b1, 32'hAA55AA55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hexspeak 0xDEADBEEF", test_num);
            reset_dut();

            serial_in = 8'hDE;
            @(negedge clk);
            serial_in = 8'hAD;
            @(negedge clk);
            serial_in = 8'hBE;
            @(negedge clk);
            serial_in = 8'hEF;
            @(negedge clk);

            #1;


            check_outputs(1'b1, 32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-byte first 0x12345678", test_num);
            reset_dut();

            serial_in = 8'h12;
            @(negedge clk);
            serial_in = 8'h34;
            @(negedge clk);
            serial_in = 8'h56;
            @(negedge clk);
            serial_in = 8'h78;
            @(negedge clk);

            #1;


            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_32bit Testbench");
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
        input expected_data_ready;
        input [31:0] expected_parallel_out;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, parallel_out=%h",
                         data_ready, parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, parallel_out=%h",
                         expected_data_ready, expected_parallel_out);
                $display("  Got:      data_ready=%b, parallel_out=%h",
                         data_ready, parallel_out);
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
        $dumpvars(0,clk, reset, serial_in, data_ready, parallel_out);
    end

endmodule
