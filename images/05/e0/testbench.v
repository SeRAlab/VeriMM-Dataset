`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start_read;
    reg start_write;
    wire busy;
    wire [7:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start_read(start_read),
        .start_write(start_write),
        .busy(busy),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            start_read = 0;
            start_write = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Simple Write Operation", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hA5;
            start_write = 1;
            @(posedge clk);
            start_write = 0;


            repeat (1) @(posedge clk);
            while (busy) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Simple Read Operation", test_num);
            reset_dut();

            @(posedge clk);
            start_read = 1;
            @(posedge clk);
            start_read = 0;


            repeat (1) @(posedge clk);
            while (busy) @(posedge clk);



            #1;




            check_outputs(1'b0, data_out, 1'b0);
        end
        endtask

    task testcase004;

        reg [7:0] captured_data;
        begin
            test_num = 4;
            $display("\nTestcase %03d: Write-then-Read Data Integrity", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h3C;
            start_write = 1;
            @(posedge clk);
            start_write = 0;
            while (busy) @(posedge clk);


            @(posedge clk);
            start_read = 1;
            @(posedge clk);
            start_read = 0;
            while (busy) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h3C, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Illegal Command Contention", test_num);
            reset_dut();

            @(posedge clk);
            start_read = 1;
            start_write = 1;
            data_in = 8'hFF;
            @(posedge clk);
            start_read = 0;
            start_write = 0;


            repeat (5) @(posedge clk);
            while (busy) @(posedge clk);




            $display("  Checking if controller returned to idle...");
            #1;

            check_outputs(1'b0, data_out, error);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Reset during busy operation", test_num);
            reset_dut();

            @(posedge clk);
            start_write = 1;
            data_in = 8'hEE;
            @(posedge clk);
            start_write = 0;


            wait(busy == 1);
            repeat (2) @(posedge clk);


            rst = 1;
            repeat (2) @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
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
        input expected_busy;
        input [7:0] expected_data_out;
        input expected_error;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, error=%b",
                         busy, data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, error=%b",
                         expected_busy, expected_data_out, expected_error);
                $display("  Got:      busy=%b, data_out=%h, error=%b",
                         busy, data_out, error);
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
        $dumpvars(0,clk, data_in, rst, start_read, start_write, busy, data_out, error);
    end

endmodule
