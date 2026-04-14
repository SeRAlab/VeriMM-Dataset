`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] parallel_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .enable(enable),
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
            enable = 0;
            parallel_in = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task run_serialization;

        input [7:0] data;
        output [7:0] collected;
        integer i;
        begin
            parallel_in = data;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            for (i = 0; i < 8; i = i + 1) begin
                collected[i] = serial_out;
                if (i < 7) begin
                    @(posedge clk);
                    #1;
                end
            end
        end
        endtask

    task testcase001;

        reg [7:0] data;
        reg [7:0] captured;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 8'hA5", test_num);
            reset_dut();
            data = 8'hA5;
            run_serialization(data, captured);

            repeat(2) @(posedge clk);
            if (captured === data)
                #1;

                check_outputs(data[7]);
            else begin
                $display("  FAIL: Sequence mismatch. Exp: %b, Got: %b", data, captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        reg [7:0] data;
        reg [7:0] captured;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 8'h5A", test_num);
            reset_dut();
            data = 8'h5A;
            run_serialization(data, captured);

            repeat(2) @(posedge clk);
            if (captured === data)
                #1;

                check_outputs(data[7]);
            else begin
                $display("  FAIL: Sequence mismatch. Exp: %b, Got: %b", data, captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        reg [7:0] data;
        reg [7:0] captured;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones 8'hFF", test_num);
            reset_dut();
            data = 8'hFF;
            run_serialization(data, captured);

            repeat(2) @(posedge clk);
            if (captured === data)
                #1;

                check_outputs(data[7]);
            else begin
                $display("  FAIL: Sequence mismatch. Exp: %b, Got: %b", data, captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [7:0] data;
        reg [7:0] captured;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros 8'h00", test_num);
            reset_dut();
            data = 8'h00;
            run_serialization(data, captured);

            repeat(2) @(posedge clk);
            if (captured === data)
                #1;

                check_outputs(data[7]);
            else begin
                $display("  FAIL: Sequence mismatch. Exp: %b, Got: %b", data, captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [7:0] data;
        reg [7:0] captured;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LSB only 8'h01", test_num);
            reset_dut();
            data = 8'h01;
            run_serialization(data, captured);

            repeat(2) @(posedge clk);
            if (captured === data)
                #1;

                check_outputs(data[7]);
            else begin
                $display("  FAIL: Sequence mismatch. Exp: %b, Got: %b", data, captured);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        reg [7:0] data;
        reg [7:0] captured;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB only 8'h80", test_num);
            reset_dut();
            data = 8'h80;
            run_serialization(data, captured);

            repeat(5) @(posedge clk);
            if (captured === data)
                #1;

                check_outputs(data[7]);
            else begin
                $display("  FAIL: Sequence mismatch. Exp: %b, Got: %b", data, captured);
                fail_count = fail_count + 1;
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
        $display("serializer Testbench");
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
        $dumpvars(0,clk, enable, parallel_in, serial_out);
    end

endmodule
