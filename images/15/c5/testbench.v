`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_byte;
    reg start;
    reg stop;
    wire SCL;
    wire SDA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .data_byte(data_byte),
        .start(start),
        .stop(stop),
        .SCL(SCL),
        .SDA(SDA)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin

        start = 0;
        stop = 0;
        data_byte = 8'h00;
        #20;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase %0d: Sending 0x55", test_num);

        data_byte = 8'h55;

        start = 1;
        #10;
        start = 0;



        #500;


        stop = 1;
        #10;
        stop = 0;


        #100;


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase %0d: Sending 0xAA", test_num);

        data_byte = 8'hAA;
        start = 1;
        #10;
        start = 0;

        #500;

        stop = 1;
        #10;
        stop = 0;

        #100;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase %0d: Sending 0xFF", test_num);

        data_byte = 8'hFF;
        start = 1;
        #10;
        start = 0;

        #500;

        stop = 1;
        #10;
        stop = 0;

        #100;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase %0d: Sending 0x00", test_num);

        data_byte = 8'h00;
        start = 1;
        #10;
        start = 0;

        #500;

        stop = 1;
        #10;
        stop = 0;

        #100;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_SCL;
        input expected_SDA;
        begin
            if (expected_SCL === (expected_SCL ^ SCL ^ expected_SCL) &&
                expected_SDA === (expected_SDA ^ SDA ^ expected_SDA)) begin
                $display("PASS");
                $display("  Outputs: SCL=%b, SDA=%b",
                         SCL, SDA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SCL=%b, SDA=%b",
                         expected_SCL, expected_SDA);
                $display("  Got:      SCL=%b, SDA=%b",
                         SCL, SDA);
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
        $dumpvars(0,clk, data_byte, start, stop, SCL, SDA);
    end

endmodule
