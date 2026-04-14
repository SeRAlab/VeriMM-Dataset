`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
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
        serial_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

        reg [4:0] test_pattern;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_pattern = 5'b10101;
            $display("Starting Testcase %0d: Shifting pattern %b", test_num, test_pattern);


            for (i = 0; i < 5; i = i + 1) begin
                serial_in = test_pattern[i];
                @(posedge clk);
                #1;
            end



            for (i = 0; i < 5; i = i + 1) begin
                #1;

                check_outputs(test_pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase002;

        reg [4:0] test_pattern;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_pattern = 5'b11111;
            $display("Starting Testcase %0d: Shifting pattern %b", test_num, test_pattern);

            for (i = 0; i < 5; i = i + 1) begin
                serial_in = test_pattern[i];
                @(posedge clk);
                #1;
            end

            for (i = 0; i < 5; i = i + 1) begin
                #1;

                check_outputs(test_pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase003;

        reg [4:0] test_pattern;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_pattern = 5'b00000;
            $display("Starting Testcase %0d: Shifting pattern %b", test_num, test_pattern);

            for (i = 0; i < 5; i = i + 1) begin
                serial_in = test_pattern[i];
                @(posedge clk);
                #1;
            end

            for (i = 0; i < 5; i = i + 1) begin
                #1;

                check_outputs(test_pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase004;

        reg [4:0] test_pattern;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_pattern = 5'b11001;
            $display("Starting Testcase %0d: Shifting pattern %b", test_num, test_pattern);

            for (i = 0; i < 5; i = i + 1) begin
                serial_in = test_pattern[i];
                @(posedge clk);
                #1;
            end

            for (i = 0; i < 5; i = i + 1) begin
                #1;

                check_outputs(test_pattern[i]);
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase005;

        reg [4:0] test_pattern;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            test_pattern = 5'b01110;
            $display("Starting Testcase %0d: Shifting pattern %b", test_num, test_pattern);

            for (i = 0; i < 5; i = i + 1) begin
                serial_in = test_pattern[i];
                @(posedge clk);
                #1;
            end

            for (i = 0; i < 5; i = i + 1) begin
                #1;

                check_outputs(test_pattern[i]);
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
        $display("SISO_Shift_Register Testbench");
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
        $dumpvars(0,clk, rst, serial_in, serial_out);
    end

endmodule
