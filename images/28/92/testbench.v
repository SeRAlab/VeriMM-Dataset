`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg send;
    wire [7:0] status_reg;
    wire tx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .send(send),
        .status_reg(status_reg),
        .tx_done(tx_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        send = 0;
        data_in = 8'h00;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Initial State Verification", test_num);
        reset_dut();



        #1;




        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Data Transmission", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 8'hA5;
        send = 1;
        @(posedge clk);
        send = 0;



        wait(tx_done == 1'b1);
        @(posedge clk);



        #1;




        check_outputs(status_reg, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: No Transmission without Send Signal", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 8'hFF;
        send = 0;

        repeat(10) @(posedge clk);


        #1;



        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Consecutive Transmissions", test_num);
        reset_dut();


        @(posedge clk);
        data_in = 8'h11;
        send = 1;
        @(posedge clk);
        send = 0;
        wait(tx_done == 1'b1);


        @(posedge clk);
        data_in = 8'h22;
        send = 1;
        @(posedge clk);
        send = 0;
        wait(tx_done == 1'b1);
        @(posedge clk);

        #1;


        check_outputs(status_reg, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reset during active transmission", test_num);
        reset_dut();

        @(posedge clk);
        data_in = 8'hDE;
        send = 1;
        repeat(2) @(posedge clk);


        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);


        #1;



        check_outputs(8'h00, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_status_reg;
        input expected_tx_done;
        begin
            if (expected_status_reg === (expected_status_reg ^ status_reg ^ expected_status_reg) &&
                expected_tx_done === (expected_tx_done ^ tx_done ^ expected_tx_done)) begin
                $display("PASS");
                $display("  Outputs: status_reg=%h, tx_done=%b",
                         status_reg, tx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status_reg=%h, tx_done=%b",
                         expected_status_reg, expected_tx_done);
                $display("  Got:      status_reg=%h, tx_done=%b",
                         status_reg, tx_done);
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
        $dumpvars(0,clk, data_in, rst_n, send, status_reg, tx_done);
    end

endmodule
