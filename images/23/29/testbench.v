`timescale 1ns/1ps

module I2C_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] address;
    reg clk;
    reg [2:0] command;
    reg rst;
    wire ack;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    I2C_Controller dut (
        .address(address),
        .clk(clk),
        .command(command),
        .rst(rst),
        .ack(ack),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        address = 7'b0;
        command = 3'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset and IDLE check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Command - State Transition to ADDRESS_SENT", test_num);
        reset_dut();
        address = 7'h5A;
        command = 3'b001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify ACK generation after Address", test_num);
        reset_dut();
        address = 7'h3C;
        command = 3'b010;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify transition to DATA_TRANSFER", test_num);
        reset_dut();
        address = 7'h12;
        command = 3'b001;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify STOP command from DATA_TRANSFER", test_num);
        reset_dut();
        address = 7'h7F;
        command = 3'b001;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);


        command = 3'b100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full Read sequence check", test_num);
        reset_dut();
        address = 7'h25;
        command = 3'b010;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("I2C_Controller Testbench");
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
        input expected_ack;
        input [1:0] expected_state;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, state=%h",
                         ack, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, state=%h",
                         expected_ack, expected_state);
                $display("  Got:      ack=%b, state=%h",
                         ack, state);
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
        $dumpvars(0,address, clk, command, rst, ack, state);
    end

endmodule
