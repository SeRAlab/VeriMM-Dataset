`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read;
    reg rst;
    reg write;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .data_in(data_in),
        .read(read),
        .rst(rst),
        .write(write),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        read = 0;
        write = 0;
        data_in = 8'h00;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Reset State Check");
        test_num = test_num + 1;
        reset_dut();

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Write Operation Busy Check");
        test_num = test_num + 1;
        reset_dut();

        data_in = 8'hA5;
        write = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 8'h00);
        write = 0;
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Read Operation Check");
        test_num = test_num + 1;
        reset_dut();


        data_in = 8'h5A;
        write = 1;
        @(posedge clk);
        #1 write = 0;


        repeat(5) @(posedge clk);


        read = 1;
        @(posedge clk);
        #1 read = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b0, 8'h5A);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Overwrite and Read Check");
        test_num = test_num + 1;
        reset_dut();


        data_in = 8'h11;
        write = 1; @(posedge clk); #1 write = 0;
        repeat(5) @(posedge clk);


        data_in = 8'hEE;
        write = 1; @(posedge clk); #1 write = 0;
        repeat(5) @(posedge clk);


        read = 1;
        @(posedge clk);
        #1 read = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0, 8'hEE);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Busy Completion Check");
        test_num = test_num + 1;
        reset_dut();

        data_in = 8'hCC;
        write = 1;
        @(posedge clk);
        #1 write = 0;


        repeat(10) @(posedge clk);


        #1;



        check_outputs(1'b0, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,clk, data_in, read, rst, write, busy, data_out);
    end

endmodule
