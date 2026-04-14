`timescale 1ns/1ps

module serializer32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    wire serial_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer32 dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .serial_out(serial_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        @(posedge clk);
        #2;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(serial_out, 1'b0);
    end
        endtask

    task testcase002;

    reg [31:0] pattern;
    reg [31:0] collected_data;
    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Serializing 0xAAAAAAAA", test_num);
        reset_dut();
        pattern = 32'hAAAAAAAA;
        data_in = pattern;


        for (i = 0; i < 32; i = i + 1) begin
            collected_data = {collected_data[30:0], serial_out};
            @(posedge clk);
            #1;
        end


        if (collected_data === pattern)
            #1;

            check_outputs(pattern[0], 1'b1);
        else
            #1;

            check_outputs(~pattern[0], 1'b1);
    end
        endtask

    task testcase003;

    reg [31:0] pattern;
    reg [31:0] collected_data;
    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Serializing 0x55555555", test_num);
        reset_dut();
        pattern = 32'h55555555;
        data_in = pattern;

        for (i = 0; i < 32; i = i + 1) begin
            collected_data = {collected_data[30:0], serial_out};
            @(posedge clk);
            #1;
        end
        if (collected_data === pattern)
            #1;

            check_outputs(pattern[0], 1'b1);
        else
            #1;

            check_outputs(~pattern[0], 1'b1);
    end
        endtask

    task testcase004;

    reg [31:0] pattern;
    reg [31:0] collected_data;
    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Serializing 0xFFFFFFFF", test_num);
        reset_dut();
        pattern = 32'hFFFFFFFF;
        data_in = pattern;

        for (i = 0; i < 32; i = i + 1) begin
            collected_data = {collected_data[30:0], serial_out};
            @(posedge clk);
            #1;
        end
        if (collected_data === pattern)
            #1;

            check_outputs(1'b1, 1'b1);
        else
            #1;

            check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    reg [31:0] pattern;
    reg [31:0] collected_data;
    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Serializing 0x12345678", test_num);
        reset_dut();
        pattern = 32'h12345678;
        data_in = pattern;

        for (i = 0; i < 32; i = i + 1) begin
            collected_data = {collected_data[30:0], serial_out};
            @(posedge clk);
            #1;
        end


        @(posedge clk); #1;
        if (collected_data === pattern && valid == 1'b0)
            #1;

            check_outputs(serial_out, 1'b0);
        else
            #1;

            check_outputs(serial_out, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer32 Testbench");
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
        input expected_valid;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b, valid=%b",
                         serial_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b, valid=%b",
                         expected_serial_out, expected_valid);
                $display("  Got:      serial_out=%b, valid=%b",
                         serial_out, valid);
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
        $dumpvars(0,clk, data_in, reset, serial_out, valid);
    end

endmodule
