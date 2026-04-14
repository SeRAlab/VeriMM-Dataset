`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_condition;
    reg stop_condition;
    reg write_data;
    wire ack;
    wire [7:0] data_out;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .reset(reset),
        .start_condition(start_condition),
        .stop_condition(stop_condition),
        .write_data(write_data),
        .ack(ack),
        .data_out(data_out),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start_condition = 0;
        stop_condition = 0;
        write_data = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase%03d: Reset and Idle Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 8'h00, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase%03d: Start Condition Generation", test_num);
        reset_dut();
        @(posedge clk);
        start_condition = 1;
        @(posedge clk);
        start_condition = 0;


        repeat(20) @(posedge clk);


        #1;



        check_outputs(1'b0, 8'h00, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase%03d: Write Operation", test_num);
        reset_dut();


        start_condition = 1;
        @(posedge clk);
        start_condition = 0;
        repeat(10) @(posedge clk);

        write_data = 1;
        @(posedge clk);
        write_data = 0;


        repeat(200) @(posedge clk);



        #1;




        check_outputs(1'b1, 8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning Testcase%03d: Read Operation", test_num);
        reset_dut();

        start_condition = 1;
        @(posedge clk);
        start_condition = 0;
        repeat(10) @(posedge clk);




        repeat(200) @(posedge clk);


        #1;



        check_outputs(1'b0, 8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nRunning Testcase%03d: Stop Condition Generation", test_num);
        reset_dut();

        stop_condition = 1;
        @(posedge clk);
        stop_condition = 0;

        repeat(50) @(posedge clk);


        #1;



        check_outputs(1'b0, 8'h00, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nRunning Testcase%03d: Full Transaction Sequence", test_num);
        reset_dut();


        start_condition = 1;
        @(posedge clk); start_condition = 0;
        repeat(20) @(posedge clk);


        write_data = 1;
        @(posedge clk); write_data = 0;
        repeat(150) @(posedge clk);


        stop_condition = 1;
        @(posedge clk); stop_condition = 0;
        repeat(50) @(posedge clk);

        #1;


        check_outputs(1'b1, 8'h00, 1'b1, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, scl=%b, sda=%b",
                         ack, data_out, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, scl=%b, sda=%b",
                         expected_ack, expected_data_out, expected_scl, expected_sda);
                $display("  Got:      ack=%b, data_out=%h, scl=%b, sda=%b",
                         ack, data_out, scl, sda);
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
        $dumpvars(0,clk, reset, start_condition, stop_condition, write_data, ack, data_out, scl, sda);
    end

endmodule
