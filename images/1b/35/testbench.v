`timescale 1ns/1ps

module serializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
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
            data_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 32'h00000001;
            enable = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking LSB is 1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 32'hFFFFFFFE;
            enable = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking LSB is 0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 32'h80000000;
            enable = 0;
            @(posedge clk);
            #1;
            enable = 1;
            repeat (31) @(posedge clk);
            #1;
            $display("Testcase %0d: Checking MSB after 31 shifts", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 32'h7FFFFFFF;
            enable = 0;
            @(posedge clk);
            #1;
            enable = 1;
            repeat (31) @(posedge clk);
            #1;
            $display("Testcase %0d: Checking MSB is 0 after 31 shifts", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 32'h00010000;
            enable = 0;
            @(posedge clk);
            #1;
            enable = 1;
            repeat (16) @(posedge clk);
            #1;
            $display("Testcase %0d: Checking Bit 16 is 1 after 16 shifts", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 32'h00000004;
            enable = 0;
            @(posedge clk);
            #1;
            enable = 1;
            repeat (2) @(posedge clk);
            #1;

            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            $display("Testcase %0d: Checking output remains constant when enable=0", test_num);
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
        $display("serializer_32bit Testbench");
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
        $dumpvars(0,clk, data_in, enable, serial_out);
    end

endmodule
