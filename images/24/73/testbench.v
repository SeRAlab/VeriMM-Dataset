`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rst;
    reg ser_en;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .ser_en(ser_en),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ser_en = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Check (0x8000)", test_num);
            reset_dut();
            data_in = 16'h8000;
            ser_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LSB Check after 16 cycles (0x0001)", test_num);
            reset_dut();
            data_in = 16'h0001;
            ser_en = 1;

            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle bit check (0x0F00)", test_num);
            reset_dut();
            data_in = 16'h0F00;
            ser_en = 1;

            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros check", test_num);
            reset_dut();
            data_in = 16'h0000;
            ser_en = 1;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones check", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            ser_en = 1;
            for (i = 0; i < 15; i = i + 1) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Serial Enable Pause check", test_num);
            reset_dut();
            data_in = 16'h4000;
            ser_en = 1;
            @(posedge clk);
            #1 ser_en = 0;
            repeat (5) @(posedge clk);
            #1 ser_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        $dumpvars(0,clk, data_in, rst, ser_en, serial_out);
    end

endmodule
