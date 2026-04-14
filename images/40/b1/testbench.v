`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
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
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task run_test;

        input [7:0] data_to_send;
        reg [7:0] captured_data;
        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();

            $display("Testcase %03d: Testing Parallel Input %b", test_num, data_to_send);


            @(posedge clk);
            parallel_in = data_to_send;
            load = 1;
            @(posedge clk);
            load = 0;




            for (i = 0; i < 8; i = i + 1) begin
                captured_data[7-i] = serial_out;
                @(posedge clk);
            end


            if (captured_data === data_to_send) begin
                $display("  PASS: Captured bitstream %b matches input.", captured_data);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Captured bitstream %b, expected %b.", captured_data, data_to_send);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase001;

        begin
            run_test(8'b10101010);
        end
        endtask

    task testcase002;

        begin
            run_test(8'b01010101);
        end
        endtask

    task testcase003;

        begin
            run_test(8'b11111111);
        end
        endtask

    task testcase004;

        begin
            run_test(8'b00000000);
        end
        endtask

    task testcase005;

        begin
            run_test(8'b10000000);
        end
        endtask

    task testcase006;

        begin
            run_test(8'b00000001);
        end
        endtask

    task testcase007;

        begin
            run_test(8'hBD);
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
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, load, parallel_in, serial_out);
    end

endmodule
