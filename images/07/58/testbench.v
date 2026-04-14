`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            test_val = 8'b10101010;
            data_in = test_val;
            $display("Running Testcase %0d: Input 8'b%b", test_num, test_val);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                #1;

                check_outputs(test_val[i]);
            end
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            test_val = 8'b01010101;
            data_in = test_val;
            $display("Running Testcase %0d: Input 8'b%b", test_num, test_val);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                #1;

                check_outputs(test_val[i]);
            end
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            test_val = 8'b00000000;
            data_in = test_val;
            $display("Running Testcase %0d: Input 8'b%b", test_num, test_val);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                #1;

                check_outputs(test_val[i]);
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            test_val = 8'b00000001;
            data_in = test_val;
            $display("Running Testcase %0d: Input 8'b%b", test_num, test_val);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                #1;

                check_outputs(test_val[i]);
            end
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            test_val = 8'b10000000;
            data_in = test_val;
            $display("Running Testcase %0d: Input 8'b%b", test_num, test_val);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                #1;

                check_outputs(test_val[i]);
            end
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            test_val = 8'b11110000;
            data_in = test_val;
            $display("Running Testcase %0d: Input 8'b%b", test_num, test_val);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                #1;

                check_outputs(test_val[i]);
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
        $dumpvars(0,clk, data_in, reset, serial_out);
    end

endmodule
