`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg error;
    reg rst;
    wire ack;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .error(error),
        .rst(rst),
        .ack(ack),
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
        data_in = 0;
        error = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Normal Transmission (No Errors)", test_num);
        reset_dut();
        data_in = 5'b10101;
        error = 0;



        fork
            begin
                wait(ack == 1);
            end
            begin
                repeat(20) @(posedge clk);
            end
        join_any


        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1, 5'b10101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Retransmission after Error", test_num);
        reset_dut();
        data_in = 5'b01110;
        error = 1;

        repeat(5) @(posedge clk);


        error = 0;

        fork
            begin
                wait(ack == 1);
            end
            begin
                repeat(40) @(posedge clk);
            end
        join_any

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1, 5'b01110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Multiple Errors and Recovery", test_num);
        reset_dut();
        data_in = 5'b11111;
        error = 1;

        repeat(10) @(posedge clk);
        error = 0;

        fork
            begin
                wait(ack == 1);
            end
            begin
                repeat(40) @(posedge clk);
            end
        join_any

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1, 5'b11111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Minimum Value Transmission", test_num);
        reset_dut();
        data_in = 5'b00000;
        error = 0;

        fork
            begin
                wait(ack == 1);
            end
            begin
                repeat(20) @(posedge clk);
            end
        join_any

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1, 5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Intermittent Error Check", test_num);
        reset_dut();
        data_in = 5'b10001;


        error = 1; @(posedge clk);
        error = 0; @(posedge clk);
        error = 1; @(posedge clk);
        error = 0;

        fork
            begin
                wait(ack == 1);
            end
            begin
                repeat(50) @(posedge clk);
            end
        join_any

        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1, 5'b10001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
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
        input expected_ack;
        input [4:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, error, rst, ack, data_out);
    end

endmodule
