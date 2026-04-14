`timescale 1ns/1ps

module shift_register_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] data_in;
    reg load;
    reg rst;
    reg serial_in;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_3bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        rst <= 1;
        load <= 0;
        data_in <= 3'b000;
        serial_in <= 0;
        @(posedge clk);
        rst <= 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset", test_num);
        reset_dut();


        #1;



        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Parallel Load", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1;
        data_in <= 3'b101;
        @(posedge clk);
        load <= 0;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Right Shift (Serial In = 1)", test_num);
        reset_dut();

        @(posedge clk);
        load <= 1; data_in <= 3'b000;
        @(posedge clk);

        load <= 0;
        serial_in <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Right Shift (Serial In = 0 from 111)", test_num);
        reset_dut();
        @(posedge clk);
        load <= 1; data_in <= 3'b111;
        @(posedge clk);
        load <= 0;
        serial_in <= 0;
        @(posedge clk);
        @(posedge clk);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority over Load", test_num);
        reset_dut();
        @(posedge clk);
        rst <= 1;
        load <= 1;
        data_in <= 3'b111;
        @(posedge clk);
        rst <= 0;
        load <= 0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_3bit Testbench");
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
        input [2:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, rst, serial_in, q);
    end

endmodule
